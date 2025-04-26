package com.jenna.snapster.domain.user.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.user.dto.UserProfileUpdateDto;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;
import com.jenna.snapster.domain.user.repository.UserProfileRepository;
import com.jenna.snapster.domain.user.repository.UserRepository;
import com.jenna.snapster.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserProfileRepository userProfileRepository;

    @Override
    public User findById(Long id) {
        return userRepository.findById(id)
            .orElseThrow(() -> new GlobalException(ErrorCode.USER_NOT_EXISTS));
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public UserProfileUpdateDto updateUserProfile(User currentUser, UserProfileUpdateDto profileUpdateDto) {
        User user = this.findById(currentUser.getId());  // 최신 정보 조회

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

}
