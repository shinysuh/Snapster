package com.jenna.snapster.domain.chat.participant.redis.service;

import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipant;
import com.jenna.snapster.domain.chat.participant.redis.repository.ChatroomRedisRepository;
import com.jenna.snapster.domain.chat.participant.repository.ChatroomParticipantRepository;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatroomParticipantRedisSyncService {

    private final ChatroomRedisRepository chatroomRedisRepository;
    private final ChatroomParticipantRepository participantRepository;

    @PostConstruct
    public void initChatroomParticipantsSyncToRedis() {
        log.info("[Redis Init] 채팅방 참여자 정보를 Redis에 적재 시작");

        List<ChatroomParticipant> allParticipants = participantRepository.findAll();

        Set<Long> chatroomIds = allParticipants.stream()
            .map(cp -> cp.getId().getUserId())
            .collect(Collectors.toSet());

        for (Long chatroomId : chatroomIds) {
            List<Long> participants = allParticipants.stream()
                .filter(cp -> cp.getId().getChatroomId().equals(chatroomId))
                .map(cp -> cp.getId().getUserId())
                .toList();

            chatroomRedisRepository.addParticipants(chatroomId, participants);
        }

        log.info("[Redis Init] 채팅방 참여자 정보를 Redis에 적재 완료");
    }
}
