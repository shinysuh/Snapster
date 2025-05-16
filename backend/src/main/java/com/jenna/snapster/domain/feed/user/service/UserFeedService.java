package com.jenna.snapster.domain.feed.user.service;

import com.jenna.snapster.domain.file.video.dto.VideoPostDto;

import java.util.List;

public interface UserFeedService {

    List<VideoPostDto> getAllUserFeeds(Long userId);

    List<VideoPostDto> getPublicUserFeeds(Long userId);

    List<VideoPostDto> getPrivateUserFeeds(Long userId);

    String evictUserFeedCache(Long userId, String type);
}
