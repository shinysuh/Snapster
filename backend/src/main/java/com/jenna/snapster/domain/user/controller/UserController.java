package com.jenna.snapster.domain.user.controller;

import com.jenna.snapster.core.security.annotation.CurrentUser;
import com.jenna.snapster.core.security.util.CustomUserDetails;
import com.jenna.snapster.domain.user.dto.UserProfileDto;
import com.jenna.snapster.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/user")
public class UserController {

    private final UserService userService;

    @GetMapping("")
    public ResponseEntity<?> getAllUsers() {
        return ResponseEntity.ok(userService.getAllUsers());
    }

    @GetMapping("/others")
    public ResponseEntity<?> getAllOtherUsers(@CurrentUser CustomUserDetails currentUser) {
        return ResponseEntity.ok(userService.getAllOtherUsers(currentUser.getUser().getId()));
    }

    @PutMapping("/profile")
    public ResponseEntity<?> updateUserProfile(@CurrentUser CustomUserDetails currentUser,
                                               @RequestBody UserProfileDto userProfile) {
        return ResponseEntity.ok(userService.updateUserProfile(currentUser.getUser(), userProfile));
    }

    @GetMapping("/online")
    public ResponseEntity<?> syncRedisOnline(@CurrentUser CustomUserDetails currentUser) {
        userService.syncRedisOnline(currentUser.getUser().getId());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/offline")
    public ResponseEntity<?> syncRedisOffline(@CurrentUser CustomUserDetails currentUser) {
        userService.syncRedisOffline(currentUser.getUser().getId());
        return ResponseEntity.ok().build();
    }
}
