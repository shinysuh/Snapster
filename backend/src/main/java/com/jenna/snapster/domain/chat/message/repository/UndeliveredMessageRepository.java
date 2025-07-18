package com.jenna.snapster.domain.chat.message.repository;

import com.jenna.snapster.domain.chat.message.entity.UndeliveredMessage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface UndeliveredMessageRepository extends JpaRepository<UndeliveredMessage, Long> {

}
