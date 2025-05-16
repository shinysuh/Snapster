package com.jenna.snapster.domain.feed.user.service.impl;

import com.jenna.snapster.domain.feed.user.repository.UserFeedRepository;
import com.jenna.snapster.domain.feed.user.service.UserFeedService;
import com.jenna.snapster.domain.file.entity.UploadedFile;
import lombok.RequiredArgsConstructor;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UserFeedServiceImpl implements UserFeedService {

    private final UserFeedRepository userFeedRepository;

    @Cacheable(value = "userFeeds", key = "#userId")
    @Override
    public List<UploadedFile> getUserFeeds(Long userId) {
        return userFeedRepository.findByUserIdAndIsDeletedFalseOrderByUploadedAtDesc(userId);
    }

    /*
            TODO - Redis 캐싱 테스트 (데이터 저장 완료)
     */


}
