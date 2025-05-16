package com.jenna.snapster.domain.feed.user.service.impl;

import com.jenna.snapster.domain.feed.user.service.UserFeedService;
import com.jenna.snapster.domain.file.video.dto.VideoPostDto;
import com.jenna.snapster.domain.file.video.entity.VideoPost;
import com.jenna.snapster.domain.file.video.repository.VideoPostRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserFeedServiceImpl implements UserFeedService {

    private final VideoPostRepository videoPostRepository;
    private final CacheManager cacheManager;

    @Cacheable(value = "userFeeds::all", key = "#userId")
    @Override
    public List<VideoPostDto> getAllUserFeeds(Long userId) {
        return this.getResponseFromVideoPost(
            videoPostRepository.findByUserIdAndVideoFileIsDeletedFalseOrderByCreatedAtDesc(userId)
        );
    }

    @Cacheable(value = "userFeeds::public", key = "#userId")
    @Override
    public List<VideoPostDto> getPublicUserFeeds(Long userId) {
        return this.getResponseFromVideoPost(
            videoPostRepository.findByUserIdAndVideoFileIsPrivateFalseAndVideoFileIsDeletedFalseOrderByCreatedAtDesc(userId)
        );
    }

    @Cacheable(value = "userFeeds::private", key = "#userId")
    @Override
    public List<VideoPostDto> getPrivateUserFeeds(Long userId) {
        return this.getResponseFromVideoPost(
            videoPostRepository.findByUserIdAndVideoFileIsPrivateTrueAndVideoFileIsDeletedFalseOrderByCreatedAtDesc(userId)
        );
    }

    @Override
    public String evictUserFeedCache(Long userId, String type) {
        cacheManager.getCache("userFeeds::" + type)
            .evictIfPresent(userId);
        return type.toUpperCase() + " cache eviction completed";
    }

    private List<VideoPostDto> getResponseFromVideoPost(List<VideoPost> videoPosts) {
        return videoPosts.stream()
            .map(VideoPostDto::new)
            .collect(Collectors.toList());
    }
}
