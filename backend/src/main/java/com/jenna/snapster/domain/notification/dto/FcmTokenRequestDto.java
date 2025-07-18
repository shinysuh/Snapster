package com.jenna.snapster.domain.notification.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.Data;

@Data
public class FcmTokenRequestDto {

    private Long userId;

    private String fcmToken;

    @JsonIgnore
    private String oldToken;
}
