package com.jenna.snapster.domain.chat.participant.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import com.jenna.snapster.domain.chat.participant.dto.ChatroomParticipantDto;
import com.jenna.snapster.domain.chat.participant.dto.InvitationDto;
import com.jenna.snapster.domain.chat.participant.dto.MultipleParticipantsRequestDto;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomReadStatus;
import com.jenna.snapster.domain.chat.participant.redis.repository.ChatroomRedisRepository;
import com.jenna.snapster.domain.chat.participant.redis.repository.OnlineUserRedisRepository;
import com.jenna.snapster.domain.chat.participant.repository.ChatroomParticipantRepository;
import com.jenna.snapster.domain.chat.participant.repository.ChatroomReadStatusRepository;
import com.jenna.snapster.domain.chat.participant.service.ChatroomParticipantService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class ChatroomParticipantServiceImpl implements ChatroomParticipantService {

    private final ChatroomParticipantRepository participantRepository;
    private final ChatroomReadStatusRepository readStatusRepository;

    private final SimpMessagingTemplate simpMessagingTemplate;
    private final ChatroomRedisRepository chatroomRedisRepository;
    private final OnlineUserRedisRepository onlineUserRedisRepository;

    @Override
    public boolean isParticipating(Long chatroomId, Long userId) {
        // Redis에 채팅방 정보 없을 경우(만료 등) 다시 동기화
        this.checkRedisKeyAndSyncIfNotExists(chatroomId);
        // 참여 여부 리턴: Redis
        return chatroomRedisRepository.isParticipant(chatroomId, userId);
//        return participantRepository.existsById(new ChatroomParticipantId(chatroomId, userId));
    }

    @Override
    public List<ChatroomParticipant> getAllByChatroom(Long chatroomId) {
        return participantRepository.findByIdChatroomIdOrderByIdUserIdAsc(chatroomId);
    }

    @Override
    public List<ChatroomParticipantDto> getAllWithReadStatusByChatroom(Long chatroomId) {
        return participantRepository.findParticipantWithReadStatusByChatroomId(chatroomId);
    }

    @Override
    public Long getIfOneOnOneChatroomExists(Long userId1, Long userId2) {
        return participantRepository.findOneOnOneChatroomId(userId1, userId2)
            .orElse(null);
    }

    @Override
    public List<ChatroomParticipant> getAllByCUserId(Long userId) {
        return participantRepository.findByIdUserId(userId);
    }

    @Override
    public List<Long> getAllParticipantsByChatroomId(Long chatroomId) {
        return participantRepository.findUserIdsByIdChatroomId(chatroomId);
    }

    @Override
    public List<Long> getAllChatroomsByUserId(Long userId) {
        return participantRepository.findChatroomIdsByIdUserId(userId);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ChatroomParticipantDto inviteUserToChatroom(ChatroomParticipantId participant, Long requestUserId) {
        Long chatroomId = participant.getChatroomId();
        // 초대 작업을 수행하는 사용자가 채팅방에 참여 중인지 확인
        this.validateRequestUser(chatroomId, requestUserId);
        // 초대 (DB)
        ChatroomParticipant newParticipant = participantRepository.save(ChatroomParticipant.of(participant));
        // redis
        chatroomRedisRepository.addParticipant(chatroomId, participant.getUserId());

        // stomp 구독 알림
        this.sendStompSubscriptionNoticeToOnlineUser(participant.getChatroomId(), participant.getUserId());

        return ChatroomParticipantDto.from(newParticipant);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public List<ChatroomParticipantDto> inviteMultipleUsersToChatroom(MultipleParticipantsRequestDto addRequestDto, Long requestUserId) {
        Long chatroomId = addRequestDto.getChatroomId();
        this.validateRequestUser(chatroomId, requestUserId);
        return this.addMultipleParticipants(chatroomId, addRequestDto.getUserIds());
    }

    @Override
    public void addInitialParticipants(ChatMessageDto messageRequest) {
        List<ChatroomParticipantDto> dd = this.addMultipleParticipants(
            messageRequest.getChatroomId(),
            List.of(
                messageRequest.getSenderId(),
                messageRequest.getReceiverId()
            )
        );
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void deleteUserFromChatroom(ChatroomParticipantId id) {
        // DB 삭제 && Redis 에서 제거
        // 채팅방에 아무도 안 남았을 경우 TTL 만료 후 자동 Redis 키 삭제
        participantRepository.deleteById(id);
        chatroomRedisRepository.removeParticipant(id.getChatroomId(), id.getUserId());
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void updateLastReadMessage(ChatroomParticipantDto participant) {
        // 사용자 validate
        ChatroomParticipantId id = participant.getId();
        this.validateRequestUser(id.getChatroomId(), id.getUserId());
        this.updateReadStatus(id, participant.getLastReadMessageId());
    }

    @Override
    public void updateSenderReadStatus(ChatMessage message) {
        ChatroomParticipantId id = new ChatroomParticipantId(message.getChatroomId(), message.getSenderId());
        this.updateReadStatus(id, message.getId());
    }

    private void updateReadStatus(ChatroomParticipantId id, Long lastReadMessageId) {
        ChatroomReadStatus status = readStatusRepository.findById(id).orElse(new ChatroomReadStatus(id));

        if (!Objects.equals(status.getLastReadMessageId(), lastReadMessageId)) {
            status.updateReadStatus(lastReadMessageId);
            readStatusRepository.save(status);
        }
    }

    private void checkRedisKeyAndSyncIfNotExists(Long chatroomId) {
        boolean hasKey = chatroomRedisRepository.existsKey(chatroomId);
        if (!hasKey) {
            this.syncParticipantsToRedisByChatroom(chatroomId);
        }
    }

    private void syncParticipantsToRedisByChatroom(Long chatroomId) {
        List<Long> participantIds = this.getAllParticipantsByChatroomId(chatroomId);
        chatroomRedisRepository.addParticipants(chatroomId, participantIds);
    }

    private List<ChatroomParticipantDto> addMultipleParticipants(Long chatroomId, List<Long> userIds) {
        List<ChatroomParticipant> entitiesToSave = this.getUsersToParticipate(chatroomId, userIds);

        // 1) DB 저장
        List<ChatroomParticipant> participants = participantRepository.saveAll(entitiesToSave);
        List<Long> participantIds = this.getParticipantsIds(participants);

        // 2) Redis 참여자 목록 동기화
        chatroomRedisRepository.addParticipants(chatroomId, participantIds);
        // 3) 초대 받은 참여자 중 온라인 참여자 stomp 구독 알림
        this.sendStompSubscriptionNoticeToOnlineUser(chatroomId, participantIds);

        return participants.stream()
            .map(ChatroomParticipantDto::from)
            .toList();
    }

    private void sendStompSubscriptionNoticeToOnlineUser(Long chatroomId, List<Long> inviteeIds) {
        for (Long invitee : inviteeIds) {
            this.sendStompSubscriptionNoticeToOnlineUser(chatroomId, invitee);
        }
    }

    private void sendStompSubscriptionNoticeToOnlineUser(Long chatroomId, Long invitedUserId) {
        if (onlineUserRedisRepository.isOnline(invitedUserId)) {
            InvitationDto payload = InvitationDto.builder()
                .chatroomId(chatroomId)
                .type("INVITE")
                .build();

            // /user/{username}/queue/invites
            simpMessagingTemplate.convertAndSendToUser(
                String.valueOf(invitedUserId),
                "/queue/invites",
                payload
            );
        }
    }

    private List<ChatroomParticipant> getUsersToParticipate(Long chatroomId, List<Long> userIds) {
        List<ChatroomParticipant> participants = new ArrayList<>();

        for (Long userId : userIds) {
            participants.add(ChatroomParticipant.of(chatroomId, userId));
        }

        return participants;
    }

    private List<Long> getParticipantsIds(List<ChatroomParticipant> participants) {
        return participants.stream()
            .map(cp -> cp.getId().getUserId())
            .toList();
    }

    private void validateRequestUser(Long chatroomId, Long requestUserId) {
        boolean isAuthorized = this.isParticipating(chatroomId, requestUserId);
        if (!isAuthorized) throw new GlobalException(ErrorCode.UNAUTHORIZED_INVITATION_REQUEST);
    }
}

