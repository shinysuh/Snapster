package com.jenna.snapster.core.security.jwt;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
@RequiredArgsConstructor
public class JwtValidator {

    @Value("${jwt.issuer}")
    private String issuer;

    private final TokenManager tokenManager;

    public boolean validateToken(String token) {
        try {
            Claims claims = tokenManager.extractAllClaims(token);
            return this.isNotExpired(claims) && this.isValidIssuer(claims);
        } catch (ExpiredJwtException e) {
            // token expired 토큰 만료
        } catch (JwtException | IllegalArgumentException e) {
            // token error | illegal argument 토큰 형식 오류
        } catch (Exception e) {
            // 알 수 없는 예외 => 관리자에 문의
        }
        return false;
    }

    private boolean isNotExpired(Claims claims) {
        return !claims.getExpiration().before(new Date());
    }

    private boolean isValidIssuer(Claims claims) {
        return issuer.equals(claims.getIssuer());
    }
}
