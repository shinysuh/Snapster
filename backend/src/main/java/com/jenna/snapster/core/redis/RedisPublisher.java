package com.jenna.snapster.core.redis;

import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import com.jenna.snapster.domain.chat.message.entity.UndeliveredMessage;
import com.jenna.snapster.domain.chat.message.repository.UndeliveredMessageRepository;
import com.jenna.snapster.domain.chat.util.ChatMessageConverter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

@Slf4j
@Service
@RequiredArgsConstructor
public class RedisPublisher {

    private final StringRedisTemplate redisTemplate;
    private final UndeliveredMessageRepository undeliveredMessageRepository;
    private final ChatMessageConverter converter;

    private static final String TOPIC_PREFIX = "chatroom:";
    private static final long RETRY_INTERVAL_MS = 5000;
    private static final int MAX_RETRY = 3;

    public boolean publish(ChatMessageDto message) {
        String topic = TOPIC_PREFIX + message.getChatroomId();
        String json = converter.toJson(message);

        // Retry 로직
        // publish 실패 시, 5초 간격으로 최대 3회 재시도
        for (int i = 0; i < MAX_RETRY; i++) {
            try {
                redisTemplate.convertAndSend(topic, json);
                return true;
            } catch (Exception e) {
                log.warn("Redis publish 실패 ({}화): {}", i + 1, e.getMessage());
                try {
                    Thread.sleep(RETRY_INTERVAL_MS);
                } catch (InterruptedException ignored) {
                }
            }
        }
        // 재전송 실패 시 undelivered_messages 테이블에 저장
        this.saveUndeliveredMessage(message);
        return false;
    }

    private void saveUndeliveredMessage(ChatMessageDto message) {
        UndeliveredMessage undeliveredMessage =
            undeliveredMessageRepository.save(new UndeliveredMessage(message));
        log.error("ERROR: 메시지 전송 실패, Undelivered Message ID: ({})",
            undeliveredMessage.getId()
        );
    }
}
