package com.jenna.snapster.domain.chat.chatroom.service.impl;

import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.chatroom.repository.ChatroomRepository;
import com.jenna.snapster.domain.chat.chatroom.service.ChatroomService;
import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import com.jenna.snapster.domain.chat.participant.redis.repository.ChatroomRedisRepository;
import com.jenna.snapster.domain.chat.participant.service.ChatroomParticipantService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatroomServiceImpl implements ChatroomService {

    private final ChatroomRepository chatroomRepository;
    private final ChatroomParticipantService participantService;
    private final ChatroomRedisRepository chatroomRedisRepository;

    @Override
    public Chatroom getChatroomById(Long chatroomId) {
        return chatroomRepository.findById(chatroomId)
            .orElse(null);
    }

    @Override
    public Chatroom openNewChatroom(ChatRequestDto chatRequest) {
        Chatroom chatroom = chatroomRepository.save(new Chatroom());

        // 1) 발신인/수신인 → DB에 채팅 참여자 목록에 추가  → 수신인 정보 FCM push 알림 시 필요
        List<ChatroomParticipant> participants = participantService.addInitialParticipants(chatRequest);
        List<Long> participantIds = participants.stream()
            .map(ChatroomParticipant::getId)
            .map(ChatroomParticipantId::getUserId)
            .toList();

        // 2) Redis 참여자 목록 동기화
        chatroomRedisRepository.addParticipants(chatroom.getId(), participantIds);

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
}
