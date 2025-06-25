package com.jenna.snapster.domain.chat.chatroom.entity;

import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;

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

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "last_message_id", referencedColumnName = "id", insertable = false, updatable = false)
    private ChatMessage lastMessage;

    @Column(nullable = false, updatable = false)
    private Instant createdAt;

    @Column(nullable = false)
    private Instant updatedAt;

    @PrePersist
    protected void onCreate() {
        this.createdAt = this.updatedAt = Instant.now();
    }

    public void updateFrom(ChatMessage message) {
        this.lastMessage = message;
        this.updatedAt = message.getCreatedAt();
    }

//    @PreUpdate
//    private void onUpdate() {
//        this.updatedAt = Instant.now();
//    }
}
