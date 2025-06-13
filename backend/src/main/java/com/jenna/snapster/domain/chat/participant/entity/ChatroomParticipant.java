package com.jenna.snapster.domain.chat.participant.entity;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "chatroom_participants")
public class ChatroomParticipant {

    @EmbeddedId
    private ChatroomParticipantId id;   // chatroomId, userId

    private Long lastReadMessageId;

    private LocalDateTime lastReadAt;

    public ChatroomParticipant(ChatroomParticipantId participantId) {
        this.id = participantId;
        this.lastReadMessageId = 0L;
        this.lastReadAt = LocalDateTime.now();
    }
}


