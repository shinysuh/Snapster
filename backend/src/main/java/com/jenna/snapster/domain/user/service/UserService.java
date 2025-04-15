package com.jenna.snapster.domain.user.service;

import com.jenna.snapster.domain.user.entity.User;

public interface UserService {

    User findById(Long id);
}
