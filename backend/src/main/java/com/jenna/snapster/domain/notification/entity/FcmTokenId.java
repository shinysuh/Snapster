package com.jenna.snapster.domain.notification.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.util.Objects;

@Data
@Embeddable
@AllArgsConstructor
@NoArgsConstructor
public class FcmTokenId implements Serializable {

    private Long userId;

    @Column(name = "fcm_token", length = 512)
    private String fcmToken;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof FcmTokenId that)) return false;
        return Objects.equals(userId, that.userId)
            && Objects.equals(fcmToken, that.fcmToken);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, fcmToken);
    }
}
