package com.jenna.snapster.core.redis;

import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import com.jenna.snapster.domain.chat.message.repository.ChatMessageRepository;
import com.jenna.snapster.domain.chat.participant.service.ChatroomParticipantService;
import com.jenna.snapster.domain.chat.util.ChatMessageConverter;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.connection.Message;
import org.springframework.data.redis.connection.MessageListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class RedisSubscriber implements MessageListener {

    private final ChatroomParticipantService participantService;
    private final ChatMessageRepository chatMessageRepository;
    private final SimpMessagingTemplate simpMessagingTemplate;
    private final ChatMessageConverter converter;

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void onMessage(Message message, byte[] pattern) {
        String body = new String(message.getBody());
        ChatMessage chatMessage = converter.fromJson(body);

        // 메시지 DB 저장
        // TODO -> chatroom 마지막 메시지 id 도 업데이트 해야함 -> service로 땡기자
        chatMessageRepository.save(chatMessage);

        // WebSocket 구독자에게 메시지 전송
        String destination = "/topic/chatroom." + chatMessage.getChatroomId();
        simpMessagingTemplate.convertAndSend(destination, chatMessage);

        // FCM 푸시 알림 (오프라인 or 미구독자)
        this.sendPushToUnsubscribedUsers(chatMessage);
    }

    private void sendPushToUnsubscribedUsers(ChatMessage message) {
        Long chatroomId = message.getChatroomId();
        List<Long> participants = participantService.getAllParticipantsByChatroomId(chatroomId);

        for (Long userId : participants) {
            if (!isUserSubscribed(userId, chatroomId)) {
                this.sendPushToUser(userId, message);
            }
        }
    }

    // 수신인 online & 채팅방 구독중
    private boolean isUserSubscribed(Long userId, Long chatroomId) {
        // TODO: Redis나 DB에서 구독 여부 확인
        return true;
    }

    private void sendPushToUser(Long userId, ChatMessage chatMessage) {
        // TODO: FCM 푸시. "새 메시지 도착", body & data 알림 => [NotificationService]로 분리
    }

}
