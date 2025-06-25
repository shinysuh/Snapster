package com.jenna.snapster.domain.chat.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatRequestDto {
    private Long id;        // message id
    private Long chatroomId;
    private Long senderId;

    private Long receiverId;    // 수신인

    private String content;
    private String type;        // e.g. text, emoji, image

    @JsonIgnore
    private Instant createdAt;
    private String clientMessageId;

    @JsonProperty("isDeleted")
    private boolean isDelete;
}
