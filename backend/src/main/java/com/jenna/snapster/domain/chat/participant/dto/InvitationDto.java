package com.jenna.snapster.domain.chat.participant.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class InvitationDto {
    private Long chatroomId;
    private String type;
}
