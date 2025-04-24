package com.jenna.snapster.domain.oauth.controller;

import com.jenna.snapster.core.security.util.SecurityUtil;
import com.jenna.snapster.domain.user.dto.UserResponseDto;
import com.jenna.snapster.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class OAuthController {

    @GetMapping("/me")
    public ResponseEntity<?> getLoginUserInfo() {
        User user = SecurityUtil.getCurentUser();
        return ResponseEntity.ok(UserResponseDto.from(user));
    }
}
