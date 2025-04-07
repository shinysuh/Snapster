package com.jenna.snapster.domain.oauth.service.impl;

import com.jenna.snapster.domain.oauth.service.OAuthUserService;
import com.jenna.snapster.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

@Service("AppleOAuthUserService")
@RequiredArgsConstructor
public class AppleOAuthUserServiceImpl implements OAuthUserService {

    @Override
    public User processOAuthUser(String provider, OAuth2User oAuth2User) {
        System.out.println("************ APPLE SERVICE CALLED ************");
        return null;
    }
}
