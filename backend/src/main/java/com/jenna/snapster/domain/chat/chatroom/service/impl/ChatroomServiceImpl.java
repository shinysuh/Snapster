package com.jenna.snapster.domain.chat.chatroom.service.impl;

import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.chatroom.repository.ChatroomRepository;
import com.jenna.snapster.domain.chat.chatroom.service.ChatroomService;
import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.participant.service.ChatroomParticipantService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class ChatroomServiceImpl implements ChatroomService {

    private final ChatroomRepository chatroomRepository;
    private final ChatroomParticipantService participantService;

    @Override
    public Chatroom getChatroomById(Long chatroomId) {
        return chatroomRepository.findById(chatroomId)
            .orElse(null);
    }

    @Override
    public Chatroom openNewChatroom(ChatRequestDto chatRequest) {
        Chatroom chatroom = chatroomRepository.save(new Chatroom());

        // 발신인/수신인 → 채팅 참여자 목록에 추가  → 수신인 정보 FCM push 알림 시 필요
        participantService.addInitialParticipants(chatRequest);

        // TODO 2: Redis에 채팅방 정보 캐싱
        // TODO 3: 신규 생성 시, 발신인 채팅방 구독 설정

        return chatroom;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public Chatroom getChatroomByIdAndCreatedIfNotExists(ChatRequestDto chatRequest) {
        Long chatroomId = chatRequest.getChatroomId();

        if (chatroomId == null) return this.openNewChatroom(chatRequest);

        Chatroom chatroom = this.getChatroomById(chatroomId);
        return chatroom != null ? chatroom : this.openNewChatroom(chatRequest);
    }
}
