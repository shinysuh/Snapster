package com.jenna.snapster.domain.file.video.dto;

import com.jenna.snapster.domain.file.uploaded.entity.UploadedFile;
import com.jenna.snapster.domain.file.video.entity.VideoPost;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Optional;

@Data
public class VideoSaveDto {
    private Long id;
    private Long videoId;
    private Long thumbnailId;
    private String title;
    private String description;
    private LocalDateTime createdAt;

    public VideoSaveDto(VideoPost post) {
        this.id = post.getId();
        this.videoId = post.getVideoFile().getId();
        this.thumbnailId = Optional.ofNullable(post.getThumbnailFile())
            .map(UploadedFile::getId)
            .orElse(null);
        this.title = post.getTitle();
        this.description = post.getDescription();
        this.createdAt = post.getCreatedAt();
    }
}
