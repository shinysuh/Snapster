package com.jenna.snapster.core.security.jwt;

import com.jenna.snapster.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class JwtProvider {

    private final TokenManager tokenManager;
    private final JwtValidator jwtValidator;

    public String createToken(User user) {
        return tokenManager.generateAccessToken(user);
    }

    public boolean isValid(String token) {
        return jwtValidator.validateToken(token);
    }

    public Long getUserId(String token) {
        return tokenManager.extractUserId(token);
    }

    public String getEmail(String token) {
        return tokenManager.extractEmail(token);
    }
}
