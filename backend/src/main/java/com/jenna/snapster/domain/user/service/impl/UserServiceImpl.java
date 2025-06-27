package com.jenna.snapster.domain.user.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.chat.participant.redis.repository.OnlineUserRedisRepository;
import com.jenna.snapster.domain.user.dto.UserProfileDto;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;
import com.jenna.snapster.domain.user.repository.UserProfileRepository;
import com.jenna.snapster.domain.user.repository.UserRepository;
import com.jenna.snapster.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserProfileRepository userProfileRepository;
    private final OnlineUserRedisRepository onlineUserRedisRepository;

    @Override
    public boolean existsById(Long userId) {
        return userRepository.existsById(userId);
    }

    @Override
    public User getUserById(Long userId) {
        return userRepository.findById(userId)
            .orElseThrow(() -> new GlobalException(ErrorCode.USER_NOT_EXISTS));
    }

    @Override
    public List<UserProfileDto> getAllUsers() {
        return this.fromEntities(userRepository.findAll());
    }

    @Override
    public List<UserProfileDto> getAllOtherUsers(Long userId) {
        return this.fromEntities(userRepository.findAllExceptCurrentUser(userId));
    }

    @Override
    public List<UserProfileDto> getAllUsersByIds(List<Long> userIds) {
        return this.fromEntities(userRepository.findAllByIdIn(userIds));
    }

    private List<UserProfileDto> fromEntities(List<User> users) {
        return users.stream().map(UserProfileDto::from).toList();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public UserProfileDto updateUserProfile(User currentUser, UserProfileDto userProfile) {
        User user = this.getUserById(currentUser.getId());  // 최신 정보 조회

        userProfile.trimFields();

        UserProfile profile = user.getProfile();
        userProfile.setUpdatedFields(user, profile);  // entity에 수정값 반영

        return userProfile;
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void updateUserProfileImage(UserProfile profile, boolean hasProfileImage, String profileImageUrl) {
        profile.setUser(null);
        profile.setHasProfileImage(hasProfileImage);
        profile.setProfileImageUrl(profileImageUrl);

        userProfileRepository.save(profile);
    }

    @Override
    public void syncRedisOnline(Long userId) {
        onlineUserRedisRepository.setOnline(userId);
    }

    @Override
    public void syncRedisOffline(Long userId) {
        onlineUserRedisRepository.setOffline(userId);
    }

}
