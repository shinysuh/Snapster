package com.jenna.snapster.domain.notification.service;

import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import com.jenna.snapster.domain.notification.dto.FcmTokenRequestDto;
import com.jenna.snapster.domain.notification.entity.FcmToken;

import java.util.List;
import java.util.Set;

public interface NotificationService {

    void sendPushToUsers(Set<Long> userId, ChatMessageDto message);

    void sendPushToUser(Long userId, ChatMessageDto message);

    List<FcmToken> getAllFcmTokensByUserId(Long userId);

    FcmToken saveFcmToken(FcmTokenRequestDto fcmToken);

    FcmToken refreshFcmToken(FcmTokenRequestDto fcmToken);

    void deleteFcmToken(FcmTokenRequestDto fcmToken);
}
