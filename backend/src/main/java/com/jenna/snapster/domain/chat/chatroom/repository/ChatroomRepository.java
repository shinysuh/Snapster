package com.jenna.snapster.domain.chat.chatroom.repository;

import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ChatroomRepository extends JpaRepository<Chatroom, Long> {

    Optional<Chatroom> findById(Long id);

    List<Chatroom> findByIdInOrderByLastMessageIdDesc(List<Long> ids);
}
