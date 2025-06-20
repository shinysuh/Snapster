package com.jenna.snapster.domain.chat.participant.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.participant.dto.AddParticipantsRequestDto;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import com.jenna.snapster.domain.chat.participant.redis.repository.ChatroomRedisRepository;
import com.jenna.snapster.domain.chat.participant.repository.ChatroomParticipantRepository;
import com.jenna.snapster.domain.chat.participant.service.ChatroomParticipantService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatroomParticipantServiceImpl implements ChatroomParticipantService {

    private final ChatroomParticipantRepository participantRepository;
    private final ChatroomRedisRepository chatroomRedisRepository;

    @Override
    public boolean isParticipating(Long chatroomId, Long userId) {
        // Redis에 채팅방 정보 없을 경우(만료 등) 다시 동기화
        this.checkRedisKeyAndSyncIfNotExists(chatroomId);
        // 참여 여부 리턴: Redis
        return chatroomRedisRepository.isParticipant(chatroomId, userId);
//        return participantRepository.existsById(new ChatroomParticipantId(chatroomId, userId));
    }

    @Override
    public List<ChatroomParticipant> getAllByChatroomId(Long chatroomId) {
        return participantRepository.findByIdChatroomIdOrderByIdUserIdAsc(chatroomId);
    }

    @Override
    public List<ChatroomParticipant> getAllByCUserId(Long userId) {
        return participantRepository.findByIdUserId(userId);
    }

    @Override
    public List<Long> getAllParticipantsByChatroomId(Long chatroomId) {
        List<ChatroomParticipant> participants = this.getAllByChatroomId(chatroomId);
        return participants.stream()
            .map(ChatroomParticipant::getId)
            .map(ChatroomParticipantId::getUserId)
            .toList();
    }

    @Override
    public List<Long> getAllChatroomsByUserId(Long userId) {
        List<ChatroomParticipant> chatrooms = this.getAllByCUserId(userId);
        return chatrooms.stream()
            .map(ChatroomParticipant::getId)
            .map(ChatroomParticipantId::getChatroomId)
            .toList();
    }

    @Override
    public ChatroomParticipant addParticipant(ChatroomParticipantId participant, Long requestUserId) {
        Long chatroomId = participant.getChatroomId();
        // 초대 작업을 수행하는 사용자가 채팅방에 참여 중인지 확인
        this.validateRequestUser(chatroomId, requestUserId);
        // 초대 (DB)
        ChatroomParticipant newParticipant = participantRepository.save(ChatroomParticipant.of(participant));
        // redis
        chatroomRedisRepository.addParticipant(chatroomId, participant.getUserId());
        return newParticipant;
    }

    @Override
    public List<ChatroomParticipant> addParticipants(AddParticipantsRequestDto addRequestDto, Long requestUserId) {
        Long chatroomId = addRequestDto.getChatroomId();
        this.validateRequestUser(chatroomId, requestUserId);
        return this.addMultipleParticipants(chatroomId, addRequestDto.getUserIds());
    }

    @Override
    public void addInitialParticipants(ChatRequestDto chatRequest) {
        List<ChatroomParticipant> dd = this.addMultipleParticipants(
            chatRequest.getChatroomId(),
            List.of(
                chatRequest.getSenderId(),
                chatRequest.getReceiverId()
            )
        );
    }

    @Override
    public void leaveChatroom(ChatroomParticipantId id) {
        // DB 삭제 && Redis 에서 제거
        // 채팅방에 아무도 안 남았을 경우 TTL 만료 후 자동 Redis 키 삭제
        participantRepository.deleteById(id);
        chatroomRedisRepository.removeParticipant(id.getChatroomId(), id.getUserId());
    }

    private void checkRedisKeyAndSyncIfNotExists(Long chatroomId) {
        boolean hasKey = chatroomRedisRepository.existsKey(chatroomId);
        if (!hasKey) {
            this.syncParticipantsToRedisByChatroom(chatroomId);
        }
    }

    private void syncParticipantsToRedisByChatroom(Long chatroomId) {
        List<ChatroomParticipant> participants = this.getAllByChatroomId(chatroomId);
        List<Long> participantIds = this.getParticipantsIds(participants);
        chatroomRedisRepository.addParticipants(chatroomId, participantIds);
    }

    private List<ChatroomParticipant> addMultipleParticipants(Long chatroomId, List<Long> userIds) {
        List<ChatroomParticipant> entitiesToSave = this.getUsersToParticipate(chatroomId, userIds);

        // 1) DB 저장
        List<ChatroomParticipant> participants = participantRepository.saveAll(entitiesToSave);
        List<Long> participantIds = this.getParticipantsIds(participants);

        // 2) Redis 참여자 목록 동기화
        chatroomRedisRepository.addParticipants(chatroomId, participantIds);
        return participants;
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
            .map(ChatroomParticipant::getId)
            .map(ChatroomParticipantId::getUserId)
            .toList();
    }

    private void validateRequestUser(Long chatroomId, Long requestUserId) {
        boolean isAuthorized = this.isParticipating(chatroomId, requestUserId);
        if (!isAuthorized) throw new GlobalException(ErrorCode.UNAUTHORIZED_INVITATION_REQUEST);
    }
}

