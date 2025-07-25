package com.jenna.snapster.core.redis;

import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import com.jenna.snapster.domain.chat.message.service.ChatMessageService;
import com.jenna.snapster.domain.chat.participant.redis.repository.ChatroomRedisRepository;
import com.jenna.snapster.domain.chat.participant.redis.repository.OnlineUserRedisRepository;
import com.jenna.snapster.domain.chat.util.ChatMessageConverter;
import com.jenna.snapster.domain.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class RedisSubscriber implements MessageListener {

    private final SimpMessagingTemplate simpMessagingTemplate;
    private final ChatMessageConverter converter;
    private final ChatMessageService chatMessageService;
    private final NotificationService notificationService;

    private final ChatroomRedisRepository chatroomRedisRepository;
    private final OnlineUserRedisRepository onlineUserRedisRepository;

    //    @Transactional(rollbackFor = Exception.class)
    @Override
    public void onMessage(Message message, byte[] pattern) {
        String body = new String(message.getBody());
        log.info("Received message: {}", body);

        try {
            ChatMessageDto messageDto = converter.fromJson(body);

            // 메시지 DB 저장 & chatroom 마지막 메시지 id 업데이트
            ChatMessage chatMessage = chatMessageService.saveChatMessageAndUpdateChatroom(messageDto);

            // WebSocket 구독자에게 메시지 전송
            String destination = "/topic/chatroom." + messageDto.getChatroomId();
            simpMessagingTemplate.convertAndSend(destination, messageDto);

            // FCM 푸시 알림 (오프라인 or 미구독자)
            this.sendPushToUnsubscribedUsers(messageDto);
        } catch (Exception e) {
            log.error("Failed to process message", e);
        }
    }

    private void sendPushToUnsubscribedUsers(ChatMessageDto message) {
        // redis에서 채팅방 참여자 전체 정보 fetch
        List<Long> participants = this.getParticipants(message.getChatroomId());

        // offline 참여자만 추출
        Set<Long> offlineParticipants = onlineUserRedisRepository.getAllOfflineParticipants(participants);
        // offline 참여자 FCM 푸시
        notificationService.sendPushToUsers(offlineParticipants, message);
    }

    private List<Long> getParticipants(Long chatroomId) {
        return chatroomRedisRepository.getParticipants(chatroomId)
            .stream()
            .map(Long::parseLong)
            .toList();
    }
}
