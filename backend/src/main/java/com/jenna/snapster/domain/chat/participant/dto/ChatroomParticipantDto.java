package com.jenna.snapster.domain.chat.participant.dto;

import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import com.jenna.snapster.domain.user.dto.UserResponseDto;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class ChatroomParticipantDto {

    private ChatroomParticipantId id;   // chatroomId, userId

    private UserResponseDto user;

    private LocalDateTime joinedAt;    // 참여 시간

    private Long lastReadMessageId = null;

    private LocalDateTime lastReadAt;

    // repository 쿼리에서 사용
    ChatroomParticipantDto(ChatroomParticipantId id,
                           LocalDateTime joinedAt,
                           Long lastReadMessageId,
                           LocalDateTime lastReadAt
    ) {
        this.id = id;
        this.joinedAt = joinedAt;
        this.lastReadMessageId = lastReadMessageId;
        this.lastReadAt = lastReadAt;
    }
}
