package com.jenna.snapster.domain.chat.chatroom.dto;

import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import com.jenna.snapster.domain.chat.participant.dto.ChatroomParticipantDto;
import lombok.Data;

import java.time.Instant;
import java.util.List;

@Data
public class ChatroomResponseDto {
    private Long id;

    private ChatMessage lastMessage;

    private List<ChatroomParticipantDto> participants;

    private Instant createdAt;

    private Instant updatedAt;

    public ChatroomResponseDto(Chatroom chatroom, List<ChatroomParticipantDto> participants) {
        this.id = chatroom.getId();
        this.lastMessage = chatroom.getLastMessage();
        this.participants = participants;
        this.createdAt = chatroom.getCreatedAt();
        this.updatedAt = chatroom.getUpdatedAt();
    }
}
