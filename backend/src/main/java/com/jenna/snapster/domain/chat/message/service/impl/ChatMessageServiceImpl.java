package com.jenna.snapster.domain.chat.message.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.core.redis.RedisPublisher;
import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.chatroom.service.ChatroomService;
import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import com.jenna.snapster.domain.chat.message.repository.ChatMessageRepository;
import com.jenna.snapster.domain.chat.message.service.ChatMessageService;
import com.jenna.snapster.domain.chat.participant.redis.repository.ChatroomRedisRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class ChatMessageServiceImpl implements ChatMessageService {

    private final ChatMessageRepository chatMessageRepository;
    private final ChatroomService chatroomService;
    private final RedisPublisher redisPublisher;
    private final ChatroomRedisRepository chatroomRedisRepository;

    @Override
    public boolean processMessage(ChatRequestDto chatRequest, String senderId) {
        // senderId & message.getSenderId() 일치 검증
        this.validateSender(chatRequest, senderId);

        // 1) 채팅방 존재 여부 확인 및 없으면 생성 -> chatroomId 반환
        Chatroom chatroom = chatroomService.getChatroomByIdAndCreatedIfNotExists(chatRequest);
        chatRequest.setChatroomId(chatroom.getId());

        // 2) 채팅방 ttl 연장
        chatroomRedisRepository.extendChatroomTTL(chatroom.getId());

        // 2) Redis 메시지 발행
        ChatMessage message = new ChatMessage(chatRequest);
        return redisPublisher.publish(message);
    }

    @Override
    public ChatMessage getRecentMessageByChatroom(Chatroom chatroom) {
        return chatMessageRepository.findByChatroomIdAndId(chatroom.getId(), chatroom.getLastMessageId())
            .orElse(null);
    }

    @Override
    public List<ChatMessage> getAllChatMessagesByChatroom(Long chatroomId) {
        return chatMessageRepository.findByChatroomId(chatroomId);
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ChatMessage saveChatMessageAndUpdateChatroom(ChatMessage message) {
        ChatMessage entity = chatMessageRepository.save(message);
        chatroomService.updateChatroomLastMessageId(message);
        return entity;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ChatMessage updateMessageToDeleted(Long userId, ChatRequestDto chatRequest) {
        this.validateSender(chatRequest, userId);
        ChatMessage message = chatMessageRepository.findByChatroomIdAndId(chatRequest.getChatroomId(), chatRequest.getId())
            .orElseThrow(() -> new GlobalException(ErrorCode.MESSAGE_NOT_FOUND));

        message.setContent("[삭제된 메시지입니다.]");
        message.setIsDeleted(true);

        return chatMessageRepository.save(message);
    }

    private void validateSender(ChatRequestDto chatRequest, Long senderId) {
        Long messageSenderId = chatRequest.getSenderId();
        if (!Objects.equals(messageSenderId, senderId)) {
            throw new GlobalException(ErrorCode.INVALID_MESSAGE_SENDER);
        }
    }

    private void validateSender(ChatRequestDto chatRequest, String senderId) {
        this.validateSender(chatRequest, Long.parseLong(senderId));
    }
}
