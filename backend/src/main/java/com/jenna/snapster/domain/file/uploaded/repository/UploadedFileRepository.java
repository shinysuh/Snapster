package com.jenna.snapster.domain.file.uploaded.repository;

import com.jenna.snapster.domain.file.uploaded.entity.UploadedFile;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UploadedFileRepository extends JpaRepository<UploadedFile, Long> {
    List<UploadedFile> findAllByUserIdAndIsDeletedFalseOrderByUploadedAtDesc(Long userId);

    Optional<UploadedFile> findByIdAndUserIdAndIsDeletedFalse(Long id, Long userId);

    Optional<UploadedFile> findByUrl(String url);

    Optional<UploadedFile> findByUrlContaining(String keyword);

    List<UploadedFile> findByUserIdAndTypeAndIsDeletedFalseOrderByUploadedAtDesc(Long userId, String type);

    List<UploadedFile> findByUserIdAndTypeAndIsPrivateFalseAndIsDeletedFalseOrderByUploadedAtDesc(Long userId, String typ);

    List<UploadedFile> findByUserIdAndTypeAndIsPrivateTrueAndIsDeletedFalseOrderByUploadedAtDesc(Long userId, String typ);
}
