package com.jenna.snapster.domain.oauth.constant;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;

import java.util.Arrays;

public enum OAuthProvider {
    KAKAO("kakao", "KakaoOAuthUserService"),
    GOOGLE("google", "GoogleOAuthUserService"),
    APPLE("apple", "AppleOAuthUserService"),

    ;

    private final String provider;
    private final String serviceName;


    OAuthProvider(String provider, String serviceName) {
        this.provider = provider;
        this.serviceName = serviceName;
    }

    public String getProvider() {
        return provider;
    }

    public String getServiceName() {
        return serviceName;
    }

    public static OAuthProvider from(String provider) {
        return Arrays.stream(values())
            .filter(prv -> prv.name().equals(provider.toUpperCase()))
            .findFirst()
            .orElseThrow(() -> new GlobalException(ErrorCode.INVALID_PROVIDER));
    }
}
