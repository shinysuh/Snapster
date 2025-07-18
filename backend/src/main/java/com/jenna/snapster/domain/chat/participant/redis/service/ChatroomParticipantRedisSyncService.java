package com.jenna.snapster.domain.chat.participant.redis.service;

import com.jenna.snapster.domain.chat.chatroom.repository.ChatroomRepository;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.redis.repository.ChatroomRedisRepository;
import com.jenna.snapster.domain.chat.participant.repository.ChatroomParticipantRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatroomParticipantRedisSyncService {

    private final ChatroomRedisRepository chatroomRedisRepository;
    private final ChatroomParticipantRepository participantRepository;
    private final ChatroomRepository chatroomRepository;

    @EventListener(ApplicationReadyEvent.class)
    @Async
    public void initChatroomParticipantsSyncToRedis() {
        log.info("[Redis Init] 채팅방 참여자 정보를 Redis에 적재 시작");

        List<ChatroomParticipant> allParticipants = participantRepository.findAll();

        Map<Long, List<ChatroomParticipant>> chatroomMap = allParticipants.stream()
            .collect(Collectors.groupingBy(cp -> cp.getId().getChatroomId()));

        for (Map.Entry<Long, List<ChatroomParticipant>> entry : chatroomMap.entrySet()) {
            Long chatroomId = entry.getKey();
            List<Long> participants = entry.getValue().stream()
                .map(cp -> cp.getId().getUserId())
                .toList();

            // 참여자 없는 방 삭제
            this.removeChatroomIfEmpty(chatroomId, participants);
            // 참여자 정보 redis 적재
            chatroomRedisRepository.addParticipants(chatroomId, participants);
        }

        log.info("[Redis Init] 채팅방 참여자 정보를 Redis에 적재 완료");
    }

    private void removeChatroomIfEmpty(Long chatroomId, List<Long> participants) {
        if (participants.isEmpty()) {
            chatroomRepository.deleteById(chatroomId);
        }
    }
}
