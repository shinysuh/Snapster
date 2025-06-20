package com.jenna.snapster.domain.chat.participant.redis.repository;

import com.jenna.snapster.core.redis.RedisTtlProperties;
import com.jenna.snapster.domain.chat.participant.redis.util.RedisKeyUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;

@Repository
@RequiredArgsConstructor
public class ChatroomRedisRepository {

    private final RedisTemplate<String, String> redisTemplate;
    private final RedisTtlProperties ttlProperties;

    public boolean existsKey(Long chatroomId) {
        String key = this.getChatroomParticipantKey(chatroomId);
        return Boolean.TRUE.equals(redisTemplate.hasKey(key));
    }

    public void addParticipant(Long chatroomId, Long userId) {
        String key = this.getChatroomParticipantKey(chatroomId);
        redisTemplate.opsForSet().add(key, userId.toString());
        this.extendChatroomTTL(key);
    }

    public void addParticipants(Long chatroomId, List<Long> participants) {
        String key = this.getChatroomParticipantKey(chatroomId);
        String[] values = participants.stream()
            .map(String::valueOf)
            .toArray(String[]::new);
        redisTemplate.opsForSet().add(key, values);
        this.extendChatroomTTL(key);
    }

    public void removeParticipant(Long chatroomId, Long userId) {
        redisTemplate.opsForSet().remove(this.getChatroomParticipantKey(chatroomId), userId.toString());
    }

    public Set<String> getParticipants(Long chatroomId) {
        return redisTemplate.opsForSet().members(this.getChatroomParticipantKey(chatroomId));
    }

    public boolean isParticipant(Long chatroomId, Long userId) {
        return Boolean.TRUE.equals(
            redisTemplate.opsForSet()
                .isMember(
                    this.getChatroomParticipantKey(chatroomId),
                    userId.toString()
                )
        );
    }

    private void extendChatroomTTL(String key) {
        redisTemplate.expire(key, ttlProperties.getChat().getRoom(), TimeUnit.MILLISECONDS);
    }

    public void extendChatroomTTL(Long chatroomId) {
        this.extendChatroomTTL(this.getChatroomParticipantKey(chatroomId));
    }

    private String getChatroomParticipantKey(Long chatroomId) {
        return RedisKeyUtils.chatroomParticipantKey(chatroomId);
    }
}
