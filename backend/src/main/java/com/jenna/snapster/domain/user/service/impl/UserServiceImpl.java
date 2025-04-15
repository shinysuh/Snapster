package com.jenna.snapster.domain.user.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.repository.UserProfileRepository;
import com.jenna.snapster.domain.user.repository.UserRepository;
import com.jenna.snapster.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final UserProfileRepository userProfileRepository;

    @Override
    public User findById(Long id) {
        return userRepository.findById(id)
            .orElseThrow(() -> new GlobalException(ErrorCode.NOT_LOGGED_IN));
    }
}
