package com.jenna.snapster.core.security.oauth;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.jenna.snapster.core.security.jwt.JwtProvider;
import com.jenna.snapster.domain.oauth.constant.OAuthProvider;
import com.jenna.snapster.domain.oauth.repository.RefreshTokenRepository;
import com.jenna.snapster.domain.oauth.service.OAuthUserService;
import com.jenna.snapster.domain.user.entity.User;
import com.nimbusds.common.contenttype.ContentType;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.authentication.OAuth2AuthenticationToken;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.Map;

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
        String refreshToken = jwtProvider.createRefreshToken(user);

        response.setStatus(HttpServletResponse.SC_OK);
        response.setContentType(ContentType.APPLICATION_JSON.getType());
//        response.getWriter().write("{\"accessToken\":\"" + accessToken + "\"}");
        response.getWriter().write(
            new ObjectMapper().writeValueAsString(
                Map.of("accessToken", accessToken,
                    "refreshToken", refreshToken)
            )
        );

//        response.sendRedirect(redirectUri + accessToken);
        System.out.println("redirectUri: " + redirectUri + accessToken);
    }
}
