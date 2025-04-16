package com.jenna.snapster.domain.oauth.service;

import com.jenna.snapster.domain.oauth.dto.AccessTokenResponseDto;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;
import com.jenna.snapster.domain.user.repository.UserProfileRepository;
import com.jenna.snapster.domain.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public abstract class AbstractOAuthUserService implements OAuthUserService {

    protected final UserRepository userRepository;
    protected final UserProfileRepository userProfileRepository;

    protected User findOrCreateUser(AccessTokenResponseDto tokenResponse) {
        return userRepository.findByOauthProviderAndOauthId(tokenResponse.getProvider(), tokenResponse.getOauthId())
            .orElseGet(() -> {
                // 기존 유저 없을 경우, 새 유저 생성
                User user = User.builder()
                    .oauthProvider(tokenResponse.getProvider())
                    .oauthId(tokenResponse.getOauthId())
                    .email(tokenResponse.getEmail())
                    .username(tokenResponse.getUsername())
                    .build();

                UserProfile profile = UserProfile.builder()
                    .user(user)
                    .name(tokenResponse.getUsername())
                    .bio("")
                    .link("")
                    .birthday(null)
                    .hasAvatar(false)
                    .build();

                user.setProfile(profile);
                return userRepository.save(user);
            });
    }
}
