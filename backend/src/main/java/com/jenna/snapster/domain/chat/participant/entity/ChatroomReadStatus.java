package com.jenna.snapster.domain.chat.participant.entity;

import com.jenna.snapster.domain.chat.participant.dto.ChatroomParticipantDto;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
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

    public void updateFrom(ChatroomParticipantDto dto) {
        if (dto.getLastReadMessageId() == null) return;
        this.lastReadMessageId = dto.getLastReadMessageId();
        this.lastReadAt = LocalDateTime.now();
    }
}


