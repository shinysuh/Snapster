package com.jenna.snapster.domain.file.repository;

import com.jenna.snapster.domain.file.entity.VideoPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface VideoPostRepository extends JpaRepository<VideoPost, Long> {

    List<VideoPost> findByUserIdAndVideoFileIsDeletedFalseOrderByCreatedAtDesc(Long userId);

    List<VideoPost> findByUserIdAndVideoFileIsPrivateFalseAndVideoFileIsDeletedFalseOrderByCreatedAtDesc(Long userId);

    List<VideoPost> findByUserIdAndVideoFileIsPrivateTrueAndVideoFileIsDeletedFalseOrderByCreatedAtDesc(Long userId);

}
