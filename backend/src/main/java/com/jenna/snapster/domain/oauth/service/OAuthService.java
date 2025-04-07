package com.jenna.snapster.domain.oauth.service;

import com.jenna.snapster.domain.user.entity.User;
import org.springframework.security.oauth2.core.user.OAuth2User;

public interface OAuthService {
    User processOAuthUser(String provider, OAuth2User oAuth2User);
}
