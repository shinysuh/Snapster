package com.jenna.snapster.core.security.oauth;

import com.jenna.snapster.core.security.jwt.JwtProvider;
import com.jenna.snapster.domain.oauth.constant.OAuthProvider;
import com.jenna.snapster.domain.oauth.repository.RefreshTokenRepository;
import com.jenna.snapster.domain.oauth.service.OAuthUserService;
import com.jenna.snapster.domain.user.entity.User;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Map;

@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2SuccessHandler implements AuthenticationSuccessHandler {

    private final Map<String, OAuthUserService> oAuthUserServices;
    private final JwtProvider jwtProvider;
    private final RefreshTokenRepository repository;

    @Value("${authorization.app-redirect-uri}")
    private String redirectUri;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request,
                                        HttpServletResponse response,
                                        Authentication authentication) throws IOException {
        log.info("\n========================== OAuth Success Handler Called ==========================\n");
        OAuth2AuthenticationToken token = (OAuth2AuthenticationToken) authentication;
        OAuth2User oAuth2User = token.getPrincipal();
        String providerId = token.getAuthorizedClientRegistrationId();    // "kakao"

        OAuthProvider provider = OAuthProvider.from(providerId);
        OAuthUserService oAuthUserService = oAuthUserServices.get(provider.getServiceName());

        if (oAuthUserService == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid OAuth provider");
            return;
        }

        User user = oAuthUserService.processOAuthUser(provider.getProvider(), oAuth2User);
        String accessToken = jwtProvider.createAccessToken(user);

//        log.info("\n========================== ACCESS TOKEN CREATED : {} ==========================\n", accessToken);
//
        response.sendRedirect(redirectUri + accessToken);
        System.out.println("redirectUri with AccessToken: " + redirectUri + accessToken);
    }
}
