package com.jenna.snapster.domain.chat.participant.dto;

import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import com.jenna.snapster.domain.user.dto.UserProfileDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatroomParticipantDto {

    private ChatroomParticipantId id;   // chatroomId, userId

    private UserProfileDto user;

    private Instant joinedAt;    // 참여 시간

    private Long lastReadMessageId;

    private Instant lastReadAt;

    // repository 쿼리에서 사용
    public ChatroomParticipantDto(ChatroomParticipantId id,
                                  Instant joinedAt,
                                  Long lastReadMessageId,
                                  Instant lastReadAt) {
        this.id = id;
        this.joinedAt = joinedAt;
        this.lastReadMessageId = lastReadMessageId;
        this.lastReadAt = lastReadAt;
    }

    public static ChatroomParticipantDto from(ChatroomParticipant participant) {
        UserProfileDto user = UserProfileDto.builder()
            .userId(participant.getId().getUserId())
            .build();

        return ChatroomParticipantDto.builder()
            .id(participant.getId())
            .user(user)
            .joinedAt(participant.getJoinedAt())
            .lastReadMessageId(0L)
            .lastReadAt(Instant.now())
            .build();
    }
}
