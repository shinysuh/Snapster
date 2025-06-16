package com.jenna.snapster.domain.chat.participant.redis.repository;

import com.jenna.snapster.domain.chat.participant.redis.util.RedisKeyUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Repository;

import java.util.Set;

@Repository
@RequiredArgsConstructor
public class OnlineUserRedisRepository {

    private final RedisTemplate<String, String> redisTemplate;

    public void addOnlineUser(Long userId) {
        redisTemplate.opsForSet().add(this.getOnlineUsersKey(), userId.toString());
    }

    public void removeOnlineUser(Long userId) {
        redisTemplate.opsForSet().remove(this.getOnlineUsersKey(), userId.toString());
    }

    public boolean isOnline(Long userId) {
        return Boolean.TRUE.equals(
            redisTemplate.opsForSet()
                .isMember(
                    this.getOnlineUsersKey(),
                    userId.toString()
                ));
    }

    public Set<String> getAllOnlineUsers() {
        return redisTemplate.opsForSet().members(this.getOnlineUsersKey());
    }

    private String getOnlineUsersKey() {
        return RedisKeyUtils.onlineUserGlobalKey();
    }
}
