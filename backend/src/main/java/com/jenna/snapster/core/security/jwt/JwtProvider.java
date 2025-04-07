package com.jenna.snapster.core.security.jwt;

import com.jenna.snapster.domain.user.entity.User;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.Key;
import java.util.Date;

@Component
public class JwtProvider {

    @Value("${jwt.secret}")
    private String secret;

    @Value("${jwt.expiration}")
    private Long expiration;

    private final Key secretKey = new SecretKeySpec(
        secret.getBytes(StandardCharsets.UTF_8),
        SignatureAlgorithm.HS256.getJcaName()
    );

    public String generateAccessToken(User user) {
        return Jwts.builder()
            .setSubject(String.valueOf(user.getId()))
            .claim("username", user.getUsername())
            .claim("email", user.getEmail())
            .setIssuedAt(new Date())
            .setExpiration(new Date(System.currentTimeMillis() + expiration))
            .signWith(secretKey)
            .compact();
    }

    public Long getUserIdFromToken(String token) {
        Claims claims = Jwts.parserBuilder()
            .setSigningKey(secretKey)
            .build()
            .parseClaimsJws(token)
            .getBody();

        return Long.valueOf(claims.getSubject());
    }
}
