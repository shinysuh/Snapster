package com.jenna.snapster.domain.chat.participant.dto;

import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import com.jenna.snapster.domain.user.dto.UserResponseDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatroomParticipantDto {

    private ChatroomParticipantId id;   // chatroomId, userId

    private UserResponseDto user;

    private LocalDateTime joinedAt;    // 참여 시간

    private Long lastReadMessageId = null;

    private LocalDateTime lastReadAt;
}
