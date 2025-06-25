package com.jenna.snapster.domain.chat.participant.dto;

import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import com.jenna.snapster.domain.user.dto.UserResponseDto;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.Instant;

@Data
@AllArgsConstructor
public class ChatroomParticipantDto {

    private ChatroomParticipantId id;   // chatroomId, userId

    private UserResponseDto user;

    private Instant joinedAt;    // 참여 시간

    private Long lastReadMessageId = null;

    private Instant lastReadAt;

    // repository 쿼리에서 사용
    ChatroomParticipantDto(ChatroomParticipantId id,
                           Instant joinedAt,
                           Long lastReadMessageId,
                           Instant lastReadAt) {
        this.id = id;
        this.joinedAt = joinedAt;
        this.lastReadMessageId = lastReadMessageId;
        this.lastReadAt = lastReadAt;
    }
}
