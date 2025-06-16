package com.jenna.snapster.core.redis;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "redis.chat")
public class RedisTtlProperties {

    private long feed;
    private Chat chat = new Chat();

    @Data
    public static class Chat {
        private long room;
        private long user;
    }
}
