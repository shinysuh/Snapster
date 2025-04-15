package com.jenna.snapster.domain.oauth.service.impl;

import com.jenna.snapster.domain.oauth.service.OAuthUserService;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;
import com.jenna.snapster.domain.user.repository.UserProfileRepository;
import com.jenna.snapster.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;

@Slf4j
@Service("KakaoOAuthUserService")
@RequiredArgsConstructor
public class KakaoOAuthUserServiceImpl implements OAuthUserService {

    private final UserRepository userRepository;
    private final UserProfileRepository userProfileRepository;

    @Override
    public User processOAuthUser(String provider, OAuth2User oAuth2User) {
        log.info("************ KAKAO SERVICE CALLED ************");

        String oauthId = String.valueOf(((Number) oAuth2User.getAttribute("id")).longValue());
        Map<String, Object> kakaoAccount = (Map<String, Object>) oAuth2User.getAttributes().get("kakao_account");
        Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");

        String email = (String) kakaoAccount.get("email");
        String nickname = (String) profile.get("nickname");

        // 기존 유저 존재 확인
        Optional<User> userOpt = userRepository.findByOauthProviderAndOauthId(provider, oauthId);
        log.info("************ User {} ************", userOpt.isPresent() ? "Exists" : "Does Not Exist");
        if (userOpt.isPresent()) return userOpt.get();

        // 새 유저 등록
        User user = User.builder()
            .oauthProvider(provider)
            .oauthId(oauthId)
            .email(email)
            .username(nickname)
            .build();

        // profile 연결
        UserProfile userProfile = UserProfile.builder()
            .user(user)
            .name(user.getUsername())
            .bio("")
            .link("")
            .birthday(null)
            .hasAvatar(false)
            .build();

        user.setProfile(userProfile);

        // 유저 저장 (profile 같이 저장됨)
        user = userRepository.save(user);
        return user;
    }
}
