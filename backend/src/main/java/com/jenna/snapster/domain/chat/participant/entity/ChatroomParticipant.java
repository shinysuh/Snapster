package com.jenna.snapster.domain.chat.participant.entity;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "chatroom_participants")
public class ChatroomParticipant {

    @EmbeddedId
    private ChatroomParticipantId id;   // chatroomId, userId

    private Instant joinedAt;    // 참여 시간

    public ChatroomParticipant(ChatroomParticipantId participantId) {
        this.id = participantId;
        this.joinedAt = Instant.now();
    }

    public static ChatroomParticipant of(Long chatroomId, Long userId) {
        return ChatroomParticipant.builder()
            .id(new ChatroomParticipantId(chatroomId, userId))
            .joinedAt(Instant.now())
            .build();
    }

    public static ChatroomParticipant of(ChatroomParticipantId id) {
        return ChatroomParticipant.of(id.getChatroomId(), id.getUserId());
    }
}


