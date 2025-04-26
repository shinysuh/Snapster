package com.jenna.snapster.domain.file.repository;

import com.jenna.snapster.domain.file.entity.UploadedFile;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface UploadedFileRepository extends JpaRepository<UploadedFile, Long> {
    List<UploadedFile> findAllByUserIdAndIsDeletedFalse(Long userId);

    Optional<UploadedFile> findAllByIdAndUserIdAndIsDeletedFalse(Long id, Long userId);

    Optional<UploadedFile> findByUrl(String url);
}
