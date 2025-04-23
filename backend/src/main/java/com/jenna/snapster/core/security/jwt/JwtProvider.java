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
        return tokenManager.generateAccessToken(user);
    }

    public String createRefreshToken(User user) {
        return tokenManager.generateRefreshToken(user);
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
