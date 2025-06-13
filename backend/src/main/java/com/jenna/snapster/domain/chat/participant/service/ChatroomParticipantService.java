package com.jenna.snapster.domain.chat.participant.service;

import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;

import java.util.List;

public interface ChatroomParticipantService {

    List<ChatroomParticipant> getAllByChatroomId(Long chatroomId);

    List<Long> getAllParticipantsByChatroomId(Long chatroomId);

    ChatroomParticipant addParticipant(ChatroomParticipantId participant);

    List<ChatroomParticipant> addInitialParticipants(ChatRequestDto chatRequest);
}
