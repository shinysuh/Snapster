package com.jenna.snapster.core.security.jwt;

import com.jenna.snapster.core.security.constant.JwtKeywords;
import com.jenna.snapster.domain.user.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class JwtProvider {

    private final TokenManager tokenManager;
    private final JwtValidator jwtValidator;

    public String createAccessToken(User user) {
        String accessToken = tokenManager.generateAccessToken(user);

        // 사용자에게 새로운 리프레시 토큰을 발급하고 저장
        this.createAndSaveRefreshToken(user);

        return accessToken;
    }

    public void createAndSaveRefreshToken(User user) {
        tokenManager.generateAndSaveRefreshToken(user);
    }

    public String resolveToken(HttpServletRequest request) {
        String bearer = request.getHeader(JwtKeywords.AUTHORIZATION.getKeyword());
        if (bearer != null && bearer.startsWith(JwtKeywords.BEARER.getKeyword())) {
            return bearer.substring(7);
        }
        return null;
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
