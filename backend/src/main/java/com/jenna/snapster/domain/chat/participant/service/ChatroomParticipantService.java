package com.jenna.snapster.domain.chat.participant.service;

import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import com.jenna.snapster.domain.chat.participant.dto.ChatroomParticipantDto;
import com.jenna.snapster.domain.chat.participant.dto.MultipleParticipantsRequestDto;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;

import java.util.List;

public interface ChatroomParticipantService {

    boolean isParticipating(Long chatroomId, Long userId);

    List<ChatroomParticipant> getAllByChatroom(Long chatroomId);

    List<ChatroomParticipantDto> getAllWithReadStatusByChatroom(Long chatroomId);

    Long getIfOneOnOneChatroomExists(Long userId1, Long userId2);

    List<ChatroomParticipant> getAllByCUserId(Long userId);

    List<Long> getAllParticipantsByChatroomId(Long chatroomId);

    List<Long> getAllChatroomsByUserId(Long userId);

    ChatroomParticipantDto addParticipant(ChatroomParticipantId participant, Long requestUserId);

    List<ChatroomParticipantDto> addParticipants(MultipleParticipantsRequestDto addRequestDto, Long requestUserId);

    void addInitialParticipants(ChatMessageDto messageRequest);

    void deleteUserFromChatroom(ChatroomParticipantId id);

    void updateLastReadMessage(ChatroomParticipantDto participant);

    void updateSenderReadStatus(ChatMessage message);
}
