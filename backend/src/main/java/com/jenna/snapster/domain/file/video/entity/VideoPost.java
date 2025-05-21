package com.jenna.snapster.domain.file.video.entity;

import com.jenna.snapster.domain.file.uploaded.entity.UploadedFile;
import com.jenna.snapster.domain.file.video.dto.VideoPostDto;
import com.jenna.snapster.domain.user.entity.User;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Entity
@Table(name = "video_posts")
@Data
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class VideoPost {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    private String title;

    private String description;

    private String tags;

    @Transient
    private List<String> tagList;

    // 비디오 파일 매핑
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "video_file_id")
    private UploadedFile videoFile;

    // 썸네일 파일 매핑
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "thumbnail_file_id")
    private UploadedFile thumbnailFile;

    // 스트리밍 파일 매핑
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "streaming_file_id")
    private UploadedFile streamingFile;

    private Long likes;

    private Long comments;

    private LocalDateTime createdAt;

    public VideoPost(VideoPostDto dto) {
        this.user = User.builder().id(dto.getUserId()).build();
        this.title = dto.getTitle();
        this.description = dto.getDescription();
        this.tagList = dto.getTags();
        this.videoFile = UploadedFile.builder().id(dto.getVideoId()).build();
        this.thumbnailFile = dto.getThumbnailId() != null && dto.getThumbnailId() != 0
            ? UploadedFile.builder().id(dto.getThumbnailId()).build()
            : null;
        this.streamingFile = dto.getStreamingId() != null && dto.getStreamingId() != 0
            ? UploadedFile.builder().id(dto.getStreamingId()).build()
            : null;
        this.likes = dto.getLikes();
        this.comments = dto.getComments();
        this.createdAt = dto.getCreatedAt();
    }

    @PostLoad
    private void fillTagList() {
        if (StringUtils.isNotEmpty(tags)) {
            this.tagList = Arrays.asList(tags.split(","));
        }
    }

    @PrePersist
    @PreUpdate
    private void updateTagsString() {
        if (Objects.nonNull(tagList) && !tagList.isEmpty()) {
            this.tags = String.join(",",
                tagList.stream()
                    .map(String::trim)
                    .filter(StringUtils::isNotEmpty)
                    .collect(Collectors.toCollection(LinkedHashSet::new))
            );
        }
    }
}
