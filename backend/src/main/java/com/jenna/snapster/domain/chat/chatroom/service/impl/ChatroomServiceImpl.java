package com.jenna.snapster.domain.chat.chatroom.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.chat.chatroom.dto.ChatroomResponseDto;
import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.chatroom.repository.ChatroomRepository;
import com.jenna.snapster.domain.chat.chatroom.service.ChatroomService;
import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import com.jenna.snapster.domain.chat.participant.dto.ChatroomParticipantDto;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import com.jenna.snapster.domain.chat.participant.redis.repository.ChatroomRedisRepository;
import com.jenna.snapster.domain.chat.participant.service.ChatroomParticipantService;
import com.jenna.snapster.domain.user.dto.UserResponseDto;
import com.jenna.snapster.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ChatroomServiceImpl implements ChatroomService {

    private final ChatroomRepository chatroomRepository;
    private final ChatroomParticipantService participantService;
    private final ChatroomRedisRepository chatroomRedisRepository;
    private final UserService userService;

    @Override
    public Chatroom getChatroomById(Long chatroomId) {
        // last_message 있음
        return chatroomRepository.findById(chatroomId)
            .orElse(null);
    }

    @Override
    public ChatroomResponseDto getOneChatroomByIdAndUser(Long chatroomId, Long userId) {
        // 실제 참여자인지 확인 후 반환
        Chatroom chatroom = this.checkParticipation(chatroomId, userId);
        // 전체 메시지는 프론트에서 세팅
        return this.getChatroomResponse(chatroom);
    }

    @Override
    public ChatroomResponseDto getIfOneOnOneChatroomExists(Long senderId, Long receiverId) {
//        if (senderId.equals(receiverId)) return null;
        // 1:1 방이 있는지 여부 학인
        Long chatroomId = participantService.getIfOneOnOneChatroomExists(senderId, receiverId);
        if (chatroomId == null) return null;
        return this.getOneChatroomByIdAndUser(chatroomId, senderId);
    }

    @Override
    public List<ChatroomResponseDto> getAllChatroomsByUserId(Long userId) {
        List<Long> chatroomIds = participantService.getAllChatroomsByUserId(userId);
        List<Chatroom> chatrooms = new ArrayList<>();

        if (!chatroomIds.isEmpty()) {
            chatrooms = chatroomRepository.findByIdInOrderByLastMessageIdDesc(chatroomIds);
        }

        return chatrooms.stream()
            .map(this::getChatroomResponse)
            .toList();
    }

    @Override
    public Chatroom openNewChatroom(ChatRequestDto chatRequest) {
        this.validateReceiver(chatRequest.getReceiverId());
        Chatroom chatroom = chatroomRepository.save(new Chatroom());
        // 발신인/수신인 → DB에 채팅 참여자 목록에 추가 → Redis 동기화 → 수신인 정보 FCM push 알림 시 필요
        chatRequest.setChatroomId(chatroom.getId());
        participantService.addInitialParticipants(chatRequest);
        return chatroom;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public Chatroom getChatroomByIdAndCreatedIfNotExists(ChatRequestDto chatRequest) {
        Long chatroomId = chatRequest.getChatroomId();

        if (chatroomId != null) {
            Chatroom chatroom = this.getChatroomById(chatroomId);
            if (chatroom != null) {
                // 채팅방 정보에 수신인 정보 업데이트
                this.addReceiverAsParticipant(chatroomId, chatRequest.getReceiverId());
                return chatroom;
            }
        }

        return this.openNewChatroom(chatRequest);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public Chatroom updateChatroomLastMessageId(ChatMessage message) {
        Chatroom chatroom = this.getChatroomById(message.getChatroomId());
        chatroom.updateFrom(message);
        // 발신인 읽음 상태 업데이트
        participantService.updateSenderReadStatus(message);
        return chatroomRepository.save(chatroom);
    }

    @Override
    public void leaveChatroom(Long chatroomId, Long userId) {
        ChatroomParticipantId id = new ChatroomParticipantId(chatroomId, userId);
        participantService.deleteUserFromChatroom(id);
    }

    private ChatroomResponseDto getChatroomResponse(Chatroom chatroom) {
        List<ChatroomParticipantDto> participants = participantService.getAllWithReadStatusByChatroom(chatroom.getId());
        // 유저 세팅
        this.setParticipantsUserInfo(participants);
        return new ChatroomResponseDto(chatroom, participants);
    }

    private void setParticipantsUserInfo(List<ChatroomParticipantDto> participants) {
        List<Long> userIds = participants.stream()
            .map(cp -> cp.getId().getUserId())
            .toList();

        List<UserResponseDto> users = userService.getAllUsersByIds(userIds);
        Map<Long, UserResponseDto> userMap = users.stream()
            .collect(
                Collectors.toMap(
                    UserResponseDto::getUserId, Function.identity()
                )
            );

        participants.forEach(cp -> {
            UserResponseDto user = userMap.get(cp.getId().getUserId());
            if (user != null) cp.setUser(user);
        });
    }

    private Chatroom checkParticipation(Long chatroomId, Long userId) {
        // 실제 참여자인지 확인 후 반환
        boolean isParticipating = participantService.isParticipating(chatroomId, userId);
        Chatroom chatroom = isParticipating
            ? this.getChatroomById(chatroomId)
            : null;

        if (chatroom == null) throw new GlobalException(ErrorCode.CHATROOM_NOT_EXISTS);
        return chatroom;
    }

    private void validateReceiver(Long receiverId) {
        if (receiverId == null || receiverId == 0 || !userService.existsById(receiverId)) {
            throw new GlobalException(ErrorCode.RECEIVER_NOT_EXISTS);
        }
    }

    private void addReceiverAsParticipant(Long chatroomId, Long receiverId) {
        if (receiverId != null) {  // 여기는 null 로 넘어올 수도 있음
            chatroomRedisRepository.addParticipant(chatroomId, receiverId);
        }
    }
}
