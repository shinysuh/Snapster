package com.jenna.snapster.domain.oauth.service.impl;

import com.jenna.snapster.domain.oauth.dto.AccessTokenResponseDto;
import com.jenna.snapster.domain.oauth.service.AbstractOAuthUserService;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.repository.UserProfileRepository;
import com.jenna.snapster.domain.user.repository.UserRepository;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import java.util.Map;

@Service("GoogleOAuthUserService")
public class GoogleOAuthUserServiceImpl extends AbstractOAuthUserService {

    public GoogleOAuthUserServiceImpl(UserRepository userRepository, UserProfileRepository userProfileRepository) {
        super(userRepository, userProfileRepository);
    }

    @Override
    public User processOAuthUser(String provider, OAuth2User oAuth2User) {
        super.printServiceInfo(provider);
        Map<String, Object> attributes = oAuth2User.getAttributes();
        AccessTokenResponseDto tokenResponse = this.getTokenResponse(provider, attributes);
        return super.findOrCreateUser(tokenResponse);
    }

    private AccessTokenResponseDto getTokenResponse(String provider, Map<String, Object> attributes) {
        String oauthId = (String) attributes.get("sub");
        String email = (String) attributes.get("email");
        String name = (String) attributes.get("name");

        return AccessTokenResponseDto.builder()
            .provider(provider)
            .oauthId(oauthId)
            .email(email)
            .username(name)
            .build();
    }
}
