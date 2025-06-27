package com.jenna.snapster.domain.chat.message.entity;

import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "undelivered_messages")
public class UndeliveredMessage {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long chatroomId;

    private Long senderId;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String content;

    private String type;

    public UndeliveredMessage(ChatMessageDto message) {
        this.chatroomId = message.getChatroomId();
        this.senderId = message.getSenderId();
        this.content = message.getContent();
        this.type = message.getType();
    }
}
