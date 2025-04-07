package com.jenna.snapster.core.security.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
@RequiredArgsConstructor
public class JwtValidator {

    private final TokenManager tokenManager;

    public boolean validateToken(String token) {
        try {
            Claims claims = tokenManager.extractAllClaims(token);
            return !claims.getExpiration().before(new Date());
        } catch (ExpiredJwtException e) {
            // token expired 토큰 만료
        } catch (JwtException | IllegalArgumentException e) {
            // token error | illegal argument 토큰 형식 오류
        } catch (Exception e) {
            // 알 수 없는 예외 => 관리자에 문의
        }
        return false;
    }
}
