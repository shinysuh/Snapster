package com.jenna.snapster.domain.chat.chatroom.dto;

import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatroomResponseDto {
    private Long id;

    private Long lastMessageId;

    private ChatMessage lastMessage;

    private List<ChatMessage> messages = new ArrayList<>();

    private List<ChatroomParticipant> participants = new ArrayList<>();

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    public ChatroomResponseDto(Chatroom chatroom, ChatMessage lastMessage, List<ChatroomParticipant> participants) {
        this.id = chatroom.getId();
        this.lastMessageId = lastMessage.getId();
        this.lastMessage = lastMessage;
        this.participants = participants;
        this.createdAt = chatroom.getCreatedAt();
        this.updatedAt = chatroom.getUpdatedAt();
    }
}
