package com.jenna.snapster.domain.chat.participant.dto;

import lombok.Data;

import java.util.List;

@Data
public class MultipleParticipantsRequestDto {

    private Long chatroomId;

    private List<Long> userIds;
}
