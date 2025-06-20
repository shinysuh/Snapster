package com.jenna.snapster.core.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // SockJs fallback 지원 + CORS 허용 필요하면 설정
        registry.addEndpoint("/websocket")
            .setAllowedOriginPatterns("*")      // 운영 환경에 맞게 origin 제한 권장
            .withSockJS();
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry registry) {
        // 클라이언트 구독 prefix (/topic, /queue)
        registry.enableSimpleBroker("/topic", "/queue");
        // 클라이언트가 서버로 메시지 보낼 때 prefix (/app)
        registry.setApplicationDestinationPrefixes("/app");
    }

}
