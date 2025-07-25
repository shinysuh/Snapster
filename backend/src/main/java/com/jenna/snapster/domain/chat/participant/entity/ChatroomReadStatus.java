package com.jenna.snapster.domain.chat.participant.entity;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "chatroom_read_status")
public class ChatroomReadStatus {

    @EmbeddedId
    private ChatroomParticipantId id;   // chatroomId, userId

    private Long lastReadMessageId = null;

    private Instant lastReadAt;

    public ChatroomReadStatus(ChatroomParticipantId participantId) {
        this.id = participantId;
        this.lastReadAt = Instant.now();
    }

    public void updateReadStatus(Long lastReadMessageId) {
        if (lastReadMessageId == null) return;
        this.lastReadMessageId = lastReadMessageId;
        this.lastReadAt = Instant.now();
    }
}


