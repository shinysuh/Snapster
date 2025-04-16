package com.jenna.snapster.domain.oauth.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AccessTokenResponseDto {
    private String provider;
    private String oauthId;
    private String email;
    private String username;
}
