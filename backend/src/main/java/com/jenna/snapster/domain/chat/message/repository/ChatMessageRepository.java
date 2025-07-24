package com.jenna.snapster.domain.chat.message.repository;

import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ChatMessageRepository extends JpaRepository<ChatMessage, Long> {

    Optional<ChatMessage> findByChatroomIdAndId(Long chatroomId, Long id);

    Optional<ChatMessage> findBySenderIdAndClientMessageId(Long senderId, String clientId);

    List<ChatMessage> findByChatroomIdOrderByCreatedAtDesc(Long chatroomId);

}
