package com.jenna.snapster.domain.feed.user.service;

import com.jenna.snapster.domain.file.dto.VideoPostDto;

import java.util.List;

public interface UserFeedService {

    List<VideoPostDto> getAllUserFeeds(Long userId);

    List<VideoPostDto> getPublicUserFeeds(Long userId);

    List<VideoPostDto> getPrivateUserFeeds(Long userId);
}
