package com.jenna.snapster.domain.chat.participant.redis.util;

public class RedisKeyUtils {

    public static String chatroomParticipantKey(Long chatroomId) {
        return String.format("chatroom:%d:participants", chatroomId);
    }

    public static String userSubscriptionKey(Long userId) {
        return String.format("user:%d:subscriptions", userId);
    }

    public static String onlineUserGlobalKey() {
        return "online_users";
    }
}
