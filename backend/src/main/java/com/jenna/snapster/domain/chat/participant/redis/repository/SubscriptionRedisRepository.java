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
public class SubscriptionRedisRepository {

    private final RedisTemplate<String, String> redisTemplate;
    private final RedisTtlProperties ttlProperties;

    private static final String USER_SUBSCRIPTION_KEY = "user:%d:subscriptions";

    public void addSubscription(Long chatroomId, Long userId) {
        String key = this.getUserSubscriptionKey(userId);
        redisTemplate.opsForSet().add(key, chatroomId.toString());
        this.setTemplateTTL(key);
    }

    public void addSubscriptions(List<Long> chatroomIds, Long userId) {
        String key = this.getUserSubscriptionKey(userId);
        redisTemplate.opsForSet().add(key, this.getChatroomIdArray(chatroomIds));
        this.setTemplateTTL(key);
    }

    public void removeSubscription(Long chatroomId, Long userId) {
        redisTemplate.opsForSet().remove(this.getUserSubscriptionKey(userId), chatroomId.toString());
    }

    public void removeSubscriptions(List<Long> chatroomIds, Long userId) {
        String[] values = this.getChatroomIdArray(chatroomIds);
        redisTemplate.opsForSet().remove(this.getUserSubscriptionKey(userId), (Object[]) values);
    }

    public void removeAllSubscriptions(Long userId) {
        redisTemplate.delete(this.getUserSubscriptionKey(userId));
    }

    public Set<String> getAllSubscriptions(Long userId) {
        String key = this.getUserSubscriptionKey(userId);
        this.setTemplateTTL(key);       // 구독 연장
        return redisTemplate.opsForSet().members(key);
    }

    public boolean isSubscribing(Long chatroomId, Long userId) {
        Boolean isMember = redisTemplate.opsForSet()
            .isMember(this.getUserSubscriptionKey(userId), chatroomId.toString());
        return Boolean.TRUE.equals(isMember);
    }

    private String getUserSubscriptionKey(Long userId) {
        return RedisKeyUtils.userSubscriptionKey(userId);
    }

    private String[] getChatroomIdArray(List<Long> chatroomIds) {
        return chatroomIds.stream()
            .map(String::valueOf)
            .toArray(String[]::new);
    }

    private void setTemplateTTL(String key) {
        redisTemplate.expire(key, ttlProperties.getChat().getUser(), TimeUnit.MILLISECONDS);
    }
}
