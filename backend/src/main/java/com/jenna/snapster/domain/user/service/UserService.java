package com.jenna.snapster.domain.user.service;

import com.jenna.snapster.domain.user.dto.UserProfileUpdateDto;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;

public interface UserService {
    User findById(Long id);

    UserProfileUpdateDto updateUserProfile(Long userId, UserProfileUpdateDto profileUpdateDto);

    void updateUserProfileImage(UserProfile profile, boolean hasProfileImage, String profileImageUrl);
}
