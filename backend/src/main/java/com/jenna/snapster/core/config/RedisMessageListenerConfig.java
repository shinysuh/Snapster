package com.jenna.snapster.core.config;

import com.jenna.snapster.core.redis.RedisSubscriber;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.listener.PatternTopic;
import org.springframework.data.redis.listener.RedisMessageListenerContainer;
import org.springframework.data.redis.listener.adapter.MessageListenerAdapter;

@Configuration
@RequiredArgsConstructor
public class RedisMessageListenerConfig {

    private final RedisSubscriber redisSubscriber;

    private final RedisConnectionFactory redisConnectionFactory;

    @Bean
    public RedisMessageListenerContainer redisMessageListenerContainer() {
        RedisMessageListenerContainer container = new RedisMessageListenerContainer();
        container.setConnectionFactory(redisConnectionFactory);
        // chatrooms:* 패턴의 채널 구독
        container.addMessageListener(messageListenerAdapter(), new PatternTopic("chatroom:*"));
        return container;
    }

    @Bean
    public MessageListenerAdapter messageListenerAdapter() {
        // RedisSubscriber 클래스의 onMessage() 호출
        return new MessageListenerAdapter(redisSubscriber, "onMessage");
    }

}
