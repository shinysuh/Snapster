package com.jenna.snapster.domain.chat.chatroom.entity;

import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "chatrooms")
public class Chatroom {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long lastMessageId;

    @Column(nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = this.updatedAt = LocalDateTime.now();
    }

    public void updateFrom(ChatMessage message) {
        this.lastMessageId = message.getId();
        this.updatedAt = message.getCreatedAt();
    }

//    @PreUpdate
//    private void onUpdate() {
//        this.updatedAt = LocalDateTime.now();
//    }
}
