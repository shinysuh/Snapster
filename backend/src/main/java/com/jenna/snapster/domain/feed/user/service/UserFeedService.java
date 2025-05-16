package com.jenna.snapster.domain.feed.user.service;

import com.jenna.snapster.domain.file.entity.UploadedFile;

import java.util.List;

public interface UserFeedService {

    List<UploadedFile> getUserFeeds(Long userId);
}
