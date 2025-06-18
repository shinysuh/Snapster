package com.jenna.snapster.domain.notification.entity;

import com.jenna.snapster.domain.notification.dto.FcmTokenRequestDto;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.*;

@Data
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Entity
@Table(name = "fcm_token")
public class FcmToken {

    @EmbeddedId
    private FcmTokenId id;

    public FcmToken(FcmTokenRequestDto dto) {
        this.id = new FcmTokenId(dto.getUserId(), dto.getFcmToken());
    }

    public static FcmToken of(Long userId, String token) {
        return new FcmToken(new FcmTokenId(userId, token));
    }
}
