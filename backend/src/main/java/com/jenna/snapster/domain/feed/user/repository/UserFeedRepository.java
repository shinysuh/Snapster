package com.jenna.snapster.domain.feed.user.repository;

import com.jenna.snapster.domain.file.entity.UploadedFile;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserFeedRepository extends JpaRepository<UploadedFile, Long> {
    List<UploadedFile> findByUserIdAndIsDeletedFalseOrderByUploadedAtDesc(Long userId);
}
