package com.jenna.snapster.domain.file.entity;

import com.jenna.snapster.domain.user.entity.User;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "uploaded_file")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class UploadedFile {

    @Id
    @GeneratedValue
    private Long id;

    private Long userId;
    private String fileName;        // 원본 파일명
    private String s3FilePath;
    private String url;     // S3 Public URL 또는 Signed URL

    private LocalDateTime uploadedAt;

    private boolean isPrivate;
    private boolean isDeleted;

    public UploadedFile(Long userId, String fileName, String s3FilePath, String url) {
        this.userId = userId;
        this.fileName = fileName;
        this.s3FilePath = s3FilePath;
        this.url = url;
        this.uploadedAt = LocalDateTime.now();
    }

    public void markDeleted() {
        this.isDeleted = true;
    }
}
