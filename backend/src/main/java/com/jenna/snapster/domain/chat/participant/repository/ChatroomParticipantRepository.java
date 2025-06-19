package com.jenna.snapster.domain.chat.participant.repository;

import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatroomParticipantRepository extends JpaRepository<ChatroomParticipant, Long> {

    boolean existsById(ChatroomParticipant id);

    List<ChatroomParticipant> findByIdChatroomIdOrderByIdUserIdAsc(Long chatroomId);

    List<ChatroomParticipant> findByIdUserId(Long userId);
}
