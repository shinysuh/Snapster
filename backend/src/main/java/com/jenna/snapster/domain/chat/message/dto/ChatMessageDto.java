package com.jenna.snapster.domain.chat.message.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatMessageDto {
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

    public ChatMessageDto(ChatMessage message) {
        this.id = message.getId();
        this.chatroomId = message.getChatroomId();
        this.senderId = message.getSenderId();
        this.content = message.getContent();
        this.type = message.getType();
        this.createdAt = message.getCreatedAt();
        this.clientMessageId = message.getClientMessageId();
        this.isDelete = message.getIsDeleted();
    }
}
