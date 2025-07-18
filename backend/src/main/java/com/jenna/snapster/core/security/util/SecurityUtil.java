package com.jenna.snapster.core.security.util;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.user.entity.User;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

public class SecurityUtil {

    public static Authentication getAuthentication() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null || !authentication.isAuthenticated()) {
            throw new GlobalException(ErrorCode.NO_AUTHORIZED_USER);
        }
        return authentication;
    }

    public static User getCurentUser() {
        CustomUserDetails userDetails = (CustomUserDetails) getAuthentication().getPrincipal();
        return userDetails.getUser();
    }

    public static Long getCurrentUserId() {
        return getCurentUser().getId();
    }

    public static String getCurrentUserEmail() {
        return getCurentUser().getEmail();
    }
}
