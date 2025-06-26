package com.jenna.snapster.domain.user.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.chat.participant.redis.repository.OnlineUserRedisRepository;
import com.jenna.snapster.domain.user.dto.UserProfileUpdateDto;
import com.jenna.snapster.domain.user.dto.UserResponseDto;
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
    public List<UserResponseDto> getAllUsers() {
        return this.fromEntities(userRepository.findAll());
    }

    @Override
    public List<UserResponseDto> getAllOtherUsers(Long userId) {
        return this.fromEntities(userRepository.findAllExceptCurrentUser(userId));
    }

    @Override
    public List<UserResponseDto> getAllUsersByIds(List<Long> userIds) {
        return this.fromEntities(userRepository.findAllByIdIn(userIds));
    }

    private List<UserResponseDto> fromEntities(List<User> users) {
        return users.stream().map(UserResponseDto::from).toList();
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public UserProfileUpdateDto updateUserProfile(User currentUser, UserProfileUpdateDto profileUpdateDto) {
        User user = this.getUserById(currentUser.getId());  // 최신 정보 조회

        profileUpdateDto.trimFields();

        UserProfile profile = user.getProfile();
        profileUpdateDto.setUpdatedFields(user, profile);  // entity에 수정값 반영

        return profileUpdateDto;
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
