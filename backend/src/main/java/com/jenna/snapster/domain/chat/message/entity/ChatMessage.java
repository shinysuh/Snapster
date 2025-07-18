package com.jenna.snapster.domain.chat.message.entity;

import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "chat_messages", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"user_id", "client_message_id"})
})
public class ChatMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "chatroom_id", nullable = false)
    private Long chatroomId;

    @Column(name = "sender_id", nullable = false)
    private Long senderId;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    @Column(nullable = false, length = 20)
    private String type;        // e.g. text, emoji, image, system

    @Column(nullable = false)
    private Instant createdAt;

    @Column(nullable = false)
    private Boolean isDeleted = false;

    @Column(name = "client_message_id", length = 64)
    private String clientMessageId;

    @PrePersist
    protected void onCreate() {
        this.createdAt = Instant.now();
    }

    public ChatMessage(ChatMessageDto messageRequest) {
        this.chatroomId = messageRequest.getChatroomId();
        this.senderId = messageRequest.getSenderId();
        this.content = messageRequest.getContent();
        this.type = messageRequest.getType();
        this.createdAt = messageRequest.getCreatedAt();
        this.clientMessageId = messageRequest.getClientMessageId();
    }
}
