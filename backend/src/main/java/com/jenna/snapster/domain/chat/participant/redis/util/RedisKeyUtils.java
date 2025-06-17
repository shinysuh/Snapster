package com.jenna.snapster.domain.chat.participant.redis.util;

public class RedisKeyUtils {

    public static String chatroomParticipantKey(Long chatroomId) {
        return String.format("chatroom:%d:participants", chatroomId);
    }

    public static String onlineUserKey(Long userId) {
        return String.format("user:online:%d", userId);
    }
}
