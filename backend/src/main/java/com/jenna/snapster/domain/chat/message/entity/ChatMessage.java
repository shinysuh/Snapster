package com.jenna.snapster.domain.chat.message.entity;

import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

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
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private Boolean isDeleted = false;

    @Column(name = "client_message_id", length = 64)
    private String clientMessageId;

    @PrePersist
    protected void onCreate() {
        this.createdAt = LocalDateTime.now();
    }

    public ChatMessage(ChatRequestDto chatRequest) {
        this.chatroomId = chatRequest.getChatroomId();
        this.senderId = chatRequest.getSenderId();
        this.content = chatRequest.getContent();
        this.type = chatRequest.getType();
        this.createdAt = chatRequest.getCreatedAt();
        this.clientMessageId = chatRequest.getClientMessageId();
    }
}
