package com.jenna.snapster.domain.file.uploaded.entity;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.jenna.snapster.domain.file.uploaded.dto.UploadedFileDto;
import jakarta.persistence.*;
import lombok.*;

import java.time.Instant;

@Entity
@Table(name = "uploaded_file")
@Data
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class UploadedFile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long userId;

    private String fileName;        // 원본 파일명

    @Column(name = "s3_file_path", nullable = false)
    private String s3FilePath;

    private String url;     // S3 Public URL 또는 Signed URL

    private String type;

    private Instant uploadedAt;

    @JsonProperty("isPrivate")
    private boolean isPrivate;

    @JsonProperty("isDeleted")
    private boolean isDeleted;

    public UploadedFile(Long userId, String fileName, String s3FilePath, String url) {
        this.userId = userId;
        this.fileName = fileName;
        this.s3FilePath = s3FilePath;
        this.url = url;
        this.uploadedAt = Instant.now();
    }

    public UploadedFile(UploadedFileDto dto) {
        this.userId = dto.getUserId();
        this.fileName = dto.getFileName();
        this.s3FilePath = dto.getS3FilePath();
        this.url = dto.getUrl();
        this.type = dto.getType();
        this.uploadedAt = Instant.now();
        this.isPrivate = dto.isPrivate();
        this.isDeleted = false;
    }

    public void markDeleted() {
        this.isDeleted = true;
    }
}
