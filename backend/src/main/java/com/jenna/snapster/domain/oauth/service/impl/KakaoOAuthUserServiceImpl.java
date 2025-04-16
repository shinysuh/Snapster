package com.jenna.snapster.domain.oauth.service.impl;

import com.jenna.snapster.domain.oauth.dto.AccessTokenResponseDto;
import com.jenna.snapster.domain.oauth.service.AbstractOAuthUserService;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.repository.UserProfileRepository;
import com.jenna.snapster.domain.user.repository.UserRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Map;

@Slf4j
@Service("KakaoOAuthUserService")
public class KakaoOAuthUserServiceImpl extends AbstractOAuthUserService {

    public KakaoOAuthUserServiceImpl(UserRepository userRepository, UserProfileRepository userProfileRepository) {
        super(userRepository, userProfileRepository);
    }

    @Override
    public User processOAuthUser(String provider, OAuth2User oAuth2User) {
        log.info("************ KAKAO SERVICE CALLED ************");

        String oauthId = this.extractOauthId(oAuth2User);
        String email = this.extractEmail(oAuth2User);
        String nickname = this.extractNickname(oAuth2User);

        AccessTokenResponseDto tokenResponse = AccessTokenResponseDto.builder()
            .provider(provider)
            .oauthId(oauthId)
            .email(email)
            .username(nickname)
            .build();

        return findOrCreateUser(tokenResponse);
    }

    private String extractOauthId(OAuth2User oAuth2User) {
        return String.valueOf(((Number) oAuth2User.getAttribute("id")).longValue());
    }

    private String extractEmail(OAuth2User oAuth2User) {
        Map<String, Object> kakaoAccount = (Map<String, Object>) oAuth2User.getAttributes().get("kakao_account");
        return (String) kakaoAccount.get("email");
    }

    private String extractNickname(OAuth2User oAuth2User) {
        Map<String, Object> kakaoAccount = (Map<String, Object>) oAuth2User.getAttributes().get("kakao_account");
        Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
        return (String) profile.get("nickname");
    }

}
