package com.jenna.snapster.domain.chat.participant.service.impl;

import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
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

    @Override
    public List<ChatroomParticipant> getAllByChatroomId(Long chatroomId) {
        return participantRepository.findByIdChatroomIdOrderByIdUserIdAsc(chatroomId);
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
    public ChatroomParticipant addParticipant(ChatroomParticipantId participant) {
        return participantRepository.save(ChatroomParticipant.of(participant));
    }

    @Override
    public List<ChatroomParticipant> addInitialParticipants(ChatRequestDto chatRequest) {
        Long chatroomId = chatRequest.getChatroomId();
        Long senderId = chatRequest.getSenderId();
        Long receiverId = chatRequest.getReceiverId();

        List<ChatroomParticipant> participants = new ArrayList<>();
        participants.add(ChatroomParticipant.of(chatroomId, senderId));
        participants.add(ChatroomParticipant.of(chatroomId, receiverId));

        return participantRepository.saveAll(participants);
    }
}

