package com.jenna.snapster.domain.notification.controller;


import com.jenna.snapster.core.security.annotation.CurrentUser;
import com.jenna.snapster.core.security.util.CustomUserDetails;
import com.jenna.snapster.domain.notification.dto.FcmTokenRequestDto;
import com.jenna.snapster.domain.notification.service.NotificationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/notification")
public class NotificationController {

    private final NotificationService notificationService;

    @PostMapping("/fcm/save")
    public ResponseEntity<?> saveFcmToken(@CurrentUser CustomUserDetails currentUser,
                                          @RequestBody FcmTokenRequestDto fcmToken) {
        fcmToken.setUserId(currentUser.getUser().getId());
        return ResponseEntity.ok(notificationService.saveFcmToken(fcmToken));
    }

    @PostMapping("/fcm/refresh")
    public ResponseEntity<?> refreshFcmToken(@CurrentUser CustomUserDetails currentUser,
                                             @RequestBody FcmTokenRequestDto fcmToken) {
        fcmToken.setUserId(currentUser.getUser().getId());
        return ResponseEntity.ok(notificationService.refreshFcmToken(fcmToken));
    }

    @PostMapping("/fcm/delete")
    public ResponseEntity<?> deleteFcmToken(@CurrentUser CustomUserDetails currentUser,
                                            @RequestBody FcmTokenRequestDto fcmToken) {
        fcmToken.setUserId(currentUser.getUser().getId());
        notificationService.deleteFcmToken(fcmToken);
        return ResponseEntity.ok().build();
    }
}
