package com.jenna.snapster.domain.feed.user.controller;

import com.jenna.snapster.domain.feed.user.service.UserFeedService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/feed/user")
public class UserFeedController {

    private final UserFeedService userFeedService;

    @GetMapping("/{userId}")
    public ResponseEntity<?> getUserFeeds(@PathVariable Long userId) {
        return ResponseEntity.ok(userFeedService.getUserFeeds(userId));
    }

}
