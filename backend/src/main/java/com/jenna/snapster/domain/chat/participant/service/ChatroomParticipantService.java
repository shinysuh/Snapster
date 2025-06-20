package com.jenna.snapster.domain.chat.participant.service;

import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.participant.dto.AddParticipantsRequestDto;
import com.jenna.snapster.domain.chat.participant.dto.ChatroomParticipantDto;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;

import java.util.List;

public interface ChatroomParticipantService {

    boolean isParticipating(Long chatroomId, Long userId);

    List<ChatroomParticipant> getAllByChatroom(Long chatroomId);

    List<ChatroomParticipantDto> getAllWithReadStatusByChatroom(Long chatroomId);

    List<ChatroomParticipant> getAllByCUserId(Long userId);

    List<Long> getAllParticipantsByChatroomId(Long chatroomId);

    List<Long> getAllChatroomsByUserId(Long userId);

    ChatroomParticipant addParticipant(ChatroomParticipantId participant, Long requestUserId);

    List<ChatroomParticipant> addParticipants(AddParticipantsRequestDto addRequestDto, Long requestUserId);

    void addInitialParticipants(ChatRequestDto chatRequest);

    void deleteUserFromChatroom(ChatroomParticipantId id);

    void updateLastReadMessage(ChatroomParticipantDto participant);
}
