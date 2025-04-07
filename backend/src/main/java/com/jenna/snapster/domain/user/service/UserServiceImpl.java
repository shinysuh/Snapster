package com.jenna.snapster.domain.user.service;

import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.repository.UserRepository;
import com.jenna.snapster.domain.userprofile.entity.UserProfile;
import com.jenna.snapster.domain.userprofile.repository.UserProfileRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private UserRepository userRepository;
    private UserProfileRepository userProfileRepository;

    @Override
    public User processOAuthUser(String provider, OAuth2User oAuth2User) {
        String oauthId = String.valueOf(oAuth2User.getAttribute("id"));
        Map<String, Object> kakaoAccount = (Map<String, Object>) oAuth2User.getAttributes().get("kakao_account");
        Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");

        String email = (String) kakaoAccount.get("email");
        String nickname = (String) profile.get("nickname");

        // 기존 유저 존재 확인
        Optional<User> userOpt = userRepository.findByOauthProviderAndOauthId(provider, oauthId);
        if (userOpt.isPresent()) return userOpt.get();

        // 새 유저 등록
        User user = User.builder()
            .oauthProvider(provider)
            .oauthId(oauthId)
            .email(email)
            .username(nickname)
            .build();

        // 유저 저장
        user = userRepository.save(user);

        // profile 연결 및 저장
        UserProfile userProfile = UserProfile.builder()
            .user(user)
            .name(user.getUsername())
            .bio("")
            .link("")
            .birthday(null)
            .hasAvatar(false)
            .build();

        userProfile = userProfileRepository.save(userProfile);

        user.setProfile(userProfile);
        return user;
    }
}
