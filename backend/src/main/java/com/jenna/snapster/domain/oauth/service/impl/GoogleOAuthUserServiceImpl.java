package com.jenna.snapster.domain.oauth.service.impl;

import com.jenna.snapster.domain.oauth.service.OAuthUserService;
import com.jenna.snapster.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;


@Service("GoogleOAuthUserService")
@RequiredArgsConstructor
public class GoogleOAuthUserServiceImpl implements OAuthUserService {
    @Override
    public User processOAuthUser(String provider, OAuth2User oAuth2User) {
        System.out.println("************ GOOGLE SERVICE CALLED ************");

        return null;
    }
}
