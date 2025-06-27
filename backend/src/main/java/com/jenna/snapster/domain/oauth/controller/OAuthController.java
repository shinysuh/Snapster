package com.jenna.snapster.domain.oauth.controller;

import com.jenna.snapster.core.security.jwt.JwtProvider;
import com.jenna.snapster.core.security.util.SecurityUtil;
import com.jenna.snapster.domain.user.dto.UserProfileDto;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auth")
public class OAuthController {

    private final JwtProvider jwtProvider;
    private final UserService userService;

    @GetMapping("/me")
    public ResponseEntity<?> getLoginUserInfo() {
        User user = SecurityUtil.getCurentUser();
        userService.syncRedisOnline(user.getId());
        return ResponseEntity.ok(UserProfileDto.from(user));
    }

    @PostMapping("/dev")
    public ResponseEntity<?> getJwtForDev(@RequestBody User user) {
        // TODO : 개발 완료시 삭제 (안드로이드 애뮬레이터 자동 저장용 액세스 토큰 발급 api)
        String accessToken = jwtProvider.createAccessToken(user);
        return ResponseEntity.ok(accessToken);
    }

}
