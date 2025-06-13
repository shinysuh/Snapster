package com.jenna.snapster.domain.chat.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatRequestDto {
    private Long id;
    private Long chatroomId;
    private Long senderId;
    private Long receiverId;    // 수신인
    private String content;
    private String type;        // e.g. text, emoji, image
    private LocalDateTime createdAt;
    private String clientMessageId;
}
