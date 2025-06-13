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
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Service
@RequiredArgsConstructor
public class ChatMessageServiceImpl implements ChatMessageService {

    private final ChatMessageRepository chatMessageRepository;
    private final ChatroomService chatroomService;
    private final RedisPublisher redisPublisher;

    @Override
    public boolean processMessage(ChatRequestDto chatRequest, String senderId) {
        // senderId & message.getSenderId() 일치 검증
        this.validateSender(chatRequest, senderId);

        // 1) 채팅방 존재 여부 확인 및 없으면 생성 -> chatroomId 반환
        Chatroom chatroom = chatroomService.getChatroomByIdAndCreatedIfNotExists(chatRequest);
        chatRequest.setChatroomId(chatroom.getId());

        // 2) Redis 메시지 발행
        ChatMessage message = new ChatMessage(chatRequest);
        return redisPublisher.publish(message);
    }

    private void validateSender(ChatRequestDto chatRequest, String senderId) {
        Long messageSenderId = chatRequest.getSenderId();
        if (!Objects.equals(messageSenderId, Long.parseLong(senderId))) {
            throw new GlobalException(ErrorCode.INVALID_MESSAGE_SENDER);
        }
    }

}
