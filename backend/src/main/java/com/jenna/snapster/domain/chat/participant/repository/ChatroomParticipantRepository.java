package com.jenna.snapster.domain.chat.participant.repository;

import com.jenna.snapster.domain.chat.participant.dto.ChatroomParticipantDto;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import io.lettuce.core.dynamic.annotation.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ChatroomParticipantRepository extends JpaRepository<ChatroomParticipant, ChatroomParticipantId> {

    List<ChatroomParticipant> findByIdChatroomIdOrderByIdUserIdAsc(Long chatroomId);

    List<ChatroomParticipant> findByIdUserId(Long userId);

    @Query("""
            SELECT cp.id.userId
            FROM ChatroomParticipant cp
            WHERE cp.id.chatroomId = :chatroomId
            ORDER BY cp.id.userId ASC
        """)
    List<Long> findUserIdsByIdChatroomId(@Param("chatroomId") Long chatRoomId);

    @Query("""
            SELECT cp.id.chatroomId
            FROM ChatroomParticipant cp
            WHERE cp.id.userId = :userId
        """)
    List<Long> findChatroomIdsByIdUserId(@Param("userId") Long userId);

    @Query("""
            SELECT new com.jenna.snapster.domain.chat.participant.dto.ParticipantResponseDto(
                cp.id,
                cp.joinedAt,
                crs.lastReadMessageId,
                crs.lastReadAt
            )
            FROM ChatroomParticipant cp
            LEFT JOIN ChatroomReadStatus crs ON cp.id = crs.id
            WHERE cp.id.chatroomId = :chatroomId
            ORDER BY cp.id.userId ASC
        """)
    List<ChatroomParticipantDto> findParticipantWithReadStatusByChatroomId(@Param("chatroomId") Long chatroomId);

}
