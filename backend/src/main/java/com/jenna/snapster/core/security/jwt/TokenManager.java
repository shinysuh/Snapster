package com.jenna.snapster.core.security.jwt;

import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.user.entity.User;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.SignatureException;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;

import static com.jenna.snapster.core.exception.ErrorCode.*;

@Component
@RequiredArgsConstructor
public class TokenManager {

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.expiration}")
    private Long expiration;

    @Value("${jwt.issuer}")
    private String issuer;

    private Key secretKey;

    @PostConstruct
    public void init() {
        secretKey = new SecretKeySpec(
            secret.getBytes(StandardCharsets.UTF_8),
            SignatureAlgorithm.HS256.getJcaName()
        );
    }

    public String generateAccessToken(User user) {
        return Jwts.builder()
            .setSubject(String.valueOf(user.getId()))
            .claim("username", user.getUsername())
            .claim("email", user.getEmail())
            .setIssuer(issuer)
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + expiration))
            .signWith(secretKey)
            .compact();
    }

    public Claims extractAllClaims(String token) {
        try {
            return Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
        } catch (ExpiredJwtException e) {
            // 토큰 만료
            throw new GlobalException(TOKEN_EXPIRED);
        } catch (MalformedJwtException e) {
            // 토큰 구조 손상
            throw new GlobalException(TOKEN_MALFORMED);
        } catch (SignatureException e) {
            // 서명이 유효하지 않음
            throw new GlobalException(INVALID_SIGNATURE);
        } catch (IllegalArgumentException e) {
            // 파싱할 수 없는 토큰
            throw new GlobalException(INVALID_TOKEN);
        }
    }

    public Long extractUserId(String token) {
        return Long.parseLong(this.extractAllClaims(token).getSubject());
    }

    public String extractEmail(String token) {
        return this.extractAllClaims(token).get("email", String.class);
    }

}
