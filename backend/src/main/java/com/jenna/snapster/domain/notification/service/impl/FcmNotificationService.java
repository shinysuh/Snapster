package com.jenna.snapster.domain.notification.service.impl;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;
import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import com.jenna.snapster.domain.chat.participant.redis.repository.OnlineUserRedisRepository;
import com.jenna.snapster.domain.chat.util.ChatMessageConverter;
import com.jenna.snapster.domain.notification.dto.FcmTokenRequestDto;
import com.jenna.snapster.domain.notification.entity.FcmToken;
import com.jenna.snapster.domain.notification.repository.FcmTokenRepository;
import com.jenna.snapster.domain.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class FcmNotificationService implements NotificationService {

    private final FcmTokenRepository fcmTokenRepository;
    private final OnlineUserRedisRepository onlineUserRedisRepository;
    private final ChatMessageConverter converter;

    @Override
    public void sendPushToUsers(Set<Long> userIds, ChatMessageDto message) {
        for (Long userId : userIds) {
            this.sendPushToUser(userId, message);
        }
    }

    @Override
    public void sendPushToUser(Long userId, ChatMessageDto message) {
        List<FcmToken> fcmTokens = this.getAllFcmTokensByUserId(userId);

        for (FcmToken fcmToken : fcmTokens) {
            String token = fcmToken.getId().getFcmToken();

            Message pushMessage = Message.builder()
                .setToken(token)
                .setNotification(this.getNotification(message.getContent()))
                .putAllData(this.getPutData(message))
                .build();

            this.send(fcmToken, pushMessage);
        }
    }

    private void send(FcmToken fcmToken, Message message) {
        Long userId = fcmToken.getId().getUserId();
        String token = fcmToken.getId().getFcmToken();

        try {
            String response = FirebaseMessaging.getInstance().send(message);
            log.info("[FCM] 전송 성공: userId={}, token={}, response={}", userId, token, response);
        } catch (FirebaseMessagingException e) {
            String errorCode = e.getMessagingErrorCode().name();
            log.warn("[FCM] 전송 실패: userId={}, token={}, error={}", userId, token, errorCode);

            // 무효 토큰 정리
            this.deleteInvalidFcmToken(fcmToken, errorCode);
        }
    }

    private void deleteInvalidFcmToken(FcmToken fcmToken, String errorCode) {
        if ("UNREGISTERED".equals(errorCode)
            || "INVALID_ARGUMENT".equals(errorCode)) {
            fcmTokenRepository.delete(fcmToken);
            log.info("[FCM] 유효하지 않은 토큰 삭제: userId={}, token={}",
                fcmToken.getId().getUserId(),
                fcmToken.getId().getFcmToken());
        }
    }

    private Notification getNotification(String content) {
        String title = "[새 메시지 도착]";
        return Notification.builder()
            .setTitle(title)
            .setBody(content)
            .build();
    }

    private Map<String, String> getPutData(ChatMessageDto message) {
        Map<String, String> data = new HashMap<>();
        data.put("message", converter.toJson(message));
        return data;
    }

    @Override
    public List<FcmToken> getAllFcmTokensByUserId(Long userId) {
        return fcmTokenRepository.findByIdUserId(userId);
    }

    @Override
    public FcmToken saveFcmToken(FcmTokenRequestDto fcmToken) {
        FcmToken tokenEntity = new FcmToken(fcmToken);
        try {
            return fcmTokenRepository.save(tokenEntity);
        } catch (DataIntegrityViolationException e) {
            log.warn("중복 FCM 토큰 저장 시도 무시: {}", fcmToken);
            return tokenEntity;     // 이미 존재하면 기존 데이터 반환
        }
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public FcmToken refreshFcmToken(FcmTokenRequestDto fcmToken) {
        // delete(old)
        FcmToken oldToken = FcmToken.of(fcmToken.getUserId(), fcmToken.getOldToken());
        fcmTokenRepository.delete(oldToken);
        // insert(new)
        return this.saveFcmToken(fcmToken);
    }

    @Override
    public void deleteFcmToken(FcmTokenRequestDto fcmToken) {
        fcmTokenRepository.delete(new FcmToken(fcmToken));
        onlineUserRedisRepository.setOffline(fcmToken.getUserId());
    }
}
