package com.jenna.snapster.domain.user.service;

import com.jenna.snapster.domain.user.dto.UserProfileUpdateDto;
import com.jenna.snapster.domain.user.dto.UserResponseDto;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;

import java.util.List;

public interface UserService {
    List<UserResponseDto> getAllUsers();

    List<UserResponseDto> getAllOtherUsers(Long userId);

    List<UserResponseDto> getAllUsersByIds(List<Long> userIds);

    User getUserById(Long id);

    UserProfileUpdateDto updateUserProfile(User currentUser, UserProfileUpdateDto profileUpdateDto);

    void updateUserProfileImage(UserProfile profile, boolean hasProfileImage, String profileImageUrl);
}
