package com.jenna.snapster.domain.chat.chatroom.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.chat.chatroom.dto.ChatroomResponseDto;
import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.chatroom.repository.ChatroomRepository;
import com.jenna.snapster.domain.chat.chatroom.service.ChatroomService;
import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import com.jenna.snapster.domain.chat.message.service.ChatMessageService;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.redis.repository.ChatroomRedisRepository;
import com.jenna.snapster.domain.chat.participant.service.ChatroomParticipantService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatroomServiceImpl implements ChatroomService {

    private final ChatroomRepository chatroomRepository;
    private final ChatMessageService chatMessageService;
    private final ChatroomParticipantService participantService;
    private final ChatroomRedisRepository chatroomRedisRepository;

    @Override
    public Chatroom getChatroomById(Long chatroomId) {
        return chatroomRepository.findById(chatroomId)
            .orElse(null);
    }

    @Override
    public ChatroomResponseDto getOneChatroomByIdAndUser(Long chatroomId, Long userId) {
        // 실제 참여자인지 확인 후 반환
        Chatroom chatroom = this.checkParticipation(chatroomId, userId);

        ChatroomResponseDto response = this.getChatroomResponse(chatroom);
        // 전체 메시지 세팅
        List<ChatMessage> messages = chatMessageService.getAllChatMessagesByChatroom(chatroomId);
        response.setMessages(messages);

        return response;
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
        Chatroom chatroom = chatroomRepository.save(new Chatroom());
        // 발신인/수신인 → DB에 채팅 참여자 목록에 추가 → Redis 동기화 → 수신인 정보 FCM push 알림 시 필요
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
                chatroomRedisRepository.addParticipant(chatroomId, chatRequest.getReceiverId());
                return chatroom;
            }
        }

        return this.openNewChatroom(chatRequest);
    }

    @Override
    public Chatroom updateChatroomLastMessageId(ChatMessage message) {
        Chatroom chatroom = this.getChatroomById(message.getChatroomId());
        chatroom.setLastMessageId(message.getId());
        return chatroomRepository.save(chatroom);
    }

    private ChatroomResponseDto getChatroomResponse(Chatroom chatroom) {
        ChatMessage lastMessage = chatMessageService.getRecentMessageByChatroom(chatroom);
        List<ChatroomParticipant> participants = participantService.getAllByChatroomId(chatroom.getId());
        return new ChatroomResponseDto(chatroom, lastMessage, participants);
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
}
