package com.jenna.snapster.domain.user.service;

import com.jenna.snapster.domain.user.entity.User;
import org.springframework.security.oauth2.core.user.OAuth2User;

public interface UserService {

    User processOAuthUser(String provider, OAuth2User oAuth2User);
}
