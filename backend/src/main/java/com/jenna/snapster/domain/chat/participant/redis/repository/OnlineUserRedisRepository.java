package com.jenna.snapster.domain.chat.participant.redis.repository;

import com.jenna.snapster.domain.chat.participant.redis.util.RedisKeyUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Repository
@RequiredArgsConstructor
public class OnlineUserRedisRepository {

    private final RedisTemplate<String, String> redisTemplate;

    public void setOnline(Long userId) {
        redisTemplate.opsForValue().set(this.getOnlineUserKey(userId), "1");
    }

    public void setOffline(Long userId) {
        redisTemplate.delete(this.getOnlineUserKey(userId));
    }

    public boolean isOnline(Long userId) {
        return Boolean.TRUE.equals(redisTemplate.hasKey(this.getOnlineUserKey(userId)));
    }

    public Set<Long> getAllOnlineParticipants(List<Long> userIds) {
        return userIds.stream()
            .filter(this::isOnline)
            .collect(Collectors.toSet());
    }

    private String getOnlineUserKey(Long userId) {
        return RedisKeyUtils.onlineUserKey(userId);
    }
}
