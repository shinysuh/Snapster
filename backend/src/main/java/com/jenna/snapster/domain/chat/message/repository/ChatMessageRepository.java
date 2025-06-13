package com.jenna.snapster.domain.chat.message.repository;

import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {
}
