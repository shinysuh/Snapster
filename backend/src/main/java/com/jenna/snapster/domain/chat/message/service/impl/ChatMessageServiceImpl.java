package com.jenna.snapster.domain.chat.message.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.core.redis.RedisPublisher;
import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.chatroom.service.ChatroomService;
import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import com.jenna.snapster.domain.chat.message.repository.ChatMessageRepository;
import com.jenna.snapster.domain.chat.message.service.ChatMessageService;
import com.jenna.snapster.domain.chat.participant.redis.repository.ChatroomRedisRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatMessageServiceImpl implements ChatMessageService {

    private final ChatMessageRepository chatMessageRepository;
    private final ChatroomService chatroomService;
    private final RedisPublisher redisPublisher;
    private final ChatroomRedisRepository chatroomRedisRepository;

    @Override
    public boolean processMessage(ChatMessageDto messageRequest, Long senderId) {
        // senderId & message.getSenderId() 일치 검증
        this.validateSender(messageRequest, senderId);

        // 1) 채팅방 존재 여부 확인 및 없으면 생성 -> chatroomId 반환
        Chatroom chatroom = chatroomService.getChatroomByIdAndCreatedIfNotExists(messageRequest);
        messageRequest.setChatroomId(chatroom.getId());

        // 2) 채팅방 ttl 연장
        chatroomRedisRepository.extendChatroomTTL(chatroom.getId());

        // 2) Redis 메시지 발행
        return redisPublisher.publish(messageRequest);
    }

    @Override
    public ChatMessage getRecentMessageByChatroom(Chatroom chatroom) {
        return chatMessageRepository.findByChatroomIdAndId(chatroom.getId(), chatroom.getLastMessage().getId())
            .orElse(null);
    }

    @Override
    public List<ChatMessage> getAllChatMessagesByChatroom(Long chatroomId) {
        return chatMessageRepository.findByChatroomIdOrderByCreatedAtDesc(chatroomId);
    }

    // Transactional 운영 DB 오류로 주석 처리
//    @Transactional(rollbackFor = Exception.class, noRollbackFor = DataIntegrityViolationException.class)
    @Override
    public ChatMessage saveChatMessageAndUpdateChatroom(ChatMessageDto messageRequest) {
        ChatMessage message = new ChatMessage(messageRequest);
        ChatMessage saved;
        try {
            // 실제 저장 시도 (유니크 위반 시 예외 발생)
            saved = chatMessageRepository.save(message);
            chatroomService.updateChatroomLastMessageId(saved);
        } catch (DataIntegrityViolationException dive) {
            // 중복 삽입으로 INSERT가 실패했을 때
            log.info("중복 메시지 감지, 저장 건너뜀: {}", messageRequest.getClientMessageId());

            // 이미 저장된 메시지를 DB에서 조회해서 반환
            saved = chatMessageRepository
                .findBySenderIdAndClientMessageId(
                    message.getSenderId(),
                    messageRequest.getClientMessageId()
                ).orElse(message);
        }
        return saved;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public ChatMessage updateMessageToDeleted(Long userId, ChatMessageDto messageRequest) {
        this.validateSender(messageRequest, userId);
        ChatMessage message = chatMessageRepository.findByChatroomIdAndId(messageRequest.getChatroomId(), messageRequest.getId())
            .orElseThrow(() -> new GlobalException(ErrorCode.MESSAGE_NOT_FOUND));

        message.setContent("[삭제된 메시지입니다.]");
        message.setIsDeleted(true);

        return chatMessageRepository.save(message);
    }

    private void validateSender(ChatMessageDto messageRequest, Long senderId) {
        Long messageSenderId = messageRequest.getSenderId();
        if (!Objects.equals(messageSenderId, senderId)) {
            throw new GlobalException(ErrorCode.INVALID_MESSAGE_SENDER);
        }
    }
}
