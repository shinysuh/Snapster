package com.jenna.snapster.domain.user.service;

import com.jenna.snapster.domain.user.dto.UserProfileDto;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;

import java.util.List;

public interface UserService {

    boolean existsById(Long userId);

    User getUserById(Long userId);

    List<UserProfileDto> getAllUsers();

    List<UserProfileDto> getAllOtherUsers(Long userId);

    List<UserProfileDto> getAllUsersByIds(List<Long> userIds);

    UserProfileDto updateUserProfile(User currentUser, UserProfileDto userProfile);

    void updateUserProfileImage(UserProfile profile, boolean hasProfileImage, String profileImageUrl);

    void syncRedisOnline(Long userId);

    void syncRedisOffline(Long userId);
}
