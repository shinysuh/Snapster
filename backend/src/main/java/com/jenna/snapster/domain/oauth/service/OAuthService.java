package com.jenna.snapster.domain.oauth.service;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.core.security.jwt.TokenManager;
import com.jenna.snapster.domain.oauth.constant.OAuthProvider;
import com.jenna.snapster.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service
@RequiredArgsConstructor
public class OAuthService {

    private final Map<String, OAuthUserService> oAuthUserServices;
    private final TokenManager tokenManager;


    public String processOAuthUserAndGetJwt(String provider, OAuth2AuthenticationToken token) {
        OAuth2User oAuth2User = token.getPrincipal();
        User user = this.processOAuthUserByProvider(provider, oAuth2User);
        return tokenManager.generateAccessToken(user);
    }

    public User processOAuthUserByProvider(String providerId, OAuth2User oAuth2User) {
        OAuthProvider provider = OAuthProvider.from(providerId);
        OAuthUserService service = oAuthUserServices.get(provider.getServiceName());
        if (service == null) throw new GlobalException(ErrorCode.INVALID_ISSUER);

        return service.processOAuthUser(provider.getProvider(), oAuth2User);
    }
}
