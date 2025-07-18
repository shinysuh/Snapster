package com.jenna.snapster.domain.chat.participant.repository;

import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomReadStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChatroomReadStatusRepository extends JpaRepository<ChatroomReadStatus, ChatroomParticipantId> {

}
