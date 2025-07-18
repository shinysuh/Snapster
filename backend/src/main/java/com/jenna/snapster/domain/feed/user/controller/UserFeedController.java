package com.jenna.snapster.domain.feed.user.controller;

import com.jenna.snapster.domain.feed.user.service.UserFeedService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/feed/user")
public class UserFeedController {

    private final UserFeedService userFeedService;

    @GetMapping("/all/{userId}")
    public ResponseEntity<?> getAllUserFeeds(@PathVariable Long userId) {
        // 사용자가 포스팅한 게시물 전체 - 필요 없을 듯
        return ResponseEntity.ok(userFeedService.getAllUserFeeds(userId));
    }

    @GetMapping("/public/{userId}")
    public ResponseEntity<?> getPublicUserFeeds(@PathVariable Long userId) {
        // 공개된 피드 (default)
        return ResponseEntity.ok(userFeedService.getPublicUserFeeds(userId));
    }

    @GetMapping("/private/{userId}")
    public ResponseEntity<?> getPrivateUserFeeds(@PathVariable Long userId) {
        // 보관된 피드 (해당 위치 접근 시에만)
        return ResponseEntity.ok(userFeedService.getPrivateUserFeeds(userId));
    }

    @DeleteMapping("/cache/{type}/{userId}")
    public ResponseEntity<?> evictUserFeedCache(@PathVariable String type, @PathVariable Long userId) {
        return ResponseEntity.ok(userFeedService.evictUserFeedCache(userId, type));
    }


}
