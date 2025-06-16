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
@Table(name = "chatroom_read_status")
public class ChatroomReadStatus {

    @EmbeddedId
    private ChatroomParticipantId id;   // chatroomId, userId

    private Long lastReadMessageId = null;

    private LocalDateTime lastReadAt;

    public ChatroomReadStatus(ChatroomParticipantId participantId) {
        this.id = participantId;
        this.lastReadAt = LocalDateTime.now();
    }
}


