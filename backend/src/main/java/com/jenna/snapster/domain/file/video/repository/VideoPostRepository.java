package com.jenna.snapster.domain.file.video.repository;

import com.jenna.snapster.domain.file.video.entity.VideoPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface VideoPostRepository extends JpaRepository<VideoPost, Long> {

    Optional<VideoPost> findByVideoFileId(Long videoFileId);

    List<VideoPost> findByUserIdAndVideoFileIsDeletedFalseOrderByCreatedAtDesc(Long userId);

    List<VideoPost> findByUserIdAndVideoFileIsPrivateFalseAndVideoFileIsDeletedFalseOrderByCreatedAtDesc(Long userId);

    List<VideoPost> findByUserIdAndVideoFileIsPrivateTrueAndVideoFileIsDeletedFalseOrderByCreatedAtDesc(Long userId);

}
