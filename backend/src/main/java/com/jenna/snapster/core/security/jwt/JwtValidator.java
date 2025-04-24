package com.jenna.snapster.core.security.jwt;

import com.jenna.snapster.core.exception.GlobalException;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.Date;

import static com.jenna.snapster.core.exception.ErrorCode.*;

@Component
@RequiredArgsConstructor
public class JwtValidator {

    @Value("${authorization.jwt.issuer}")
    private String issuer;

    private final TokenManager tokenManager;

    public boolean validateToken(String token) {
        try {
            Claims claims = tokenManager.extractAllClaims(token);
            return this.isNotExpired(claims) && this.isValidIssuer(claims);
        } catch (GlobalException e) {
            throw e;
        } catch (ExpiredJwtException e) {
            // 토큰 만료
            throw new GlobalException(TOKEN_EXPIRED);
        } catch (JwtException | IllegalArgumentException e) {
            // 토큰 형식 오류
            throw new GlobalException(INVALID_TOKEN);
        } catch (Exception e) {
            throw new GlobalException(ERROR_UNKNOWN);
        }
    }

    private boolean isNotExpired(Claims claims) {
        return !claims.getExpiration().before(new Date());
    }

    private boolean isValidIssuer(Claims claims) {
        if (!issuer.equals(claims.getIssuer())) {
            throw new GlobalException(INVALID_ISSUER);
        }
        return true;
    }
}
