package com.jenna.snapster.domain.file.video.dto;

import com.jenna.snapster.domain.file.uploaded.entity.UploadedFile;
import com.jenna.snapster.domain.file.video.entity.VideoPost;
import com.jenna.snapster.domain.user.entity.UserProfile;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VideoPostDto {

    private Long id;

    private Long userId;

    private String userDisplayName;

    private String title;

    private String description;

    private Long videoId;

    private String videoUrl;

    private Long thumbnailId;

    private String thumbnailUrl;

    private Long streamingId;

    private String streamingUrl;

    private List<String> tags;

    private Long likes;

    private Long comments;

    private LocalDateTime createdAt;

    public VideoPostDto(VideoPost post) {
        this.id = post.getId();
        this.userId = post.getUser().getId();
        this.userDisplayName = Optional.ofNullable(post.getUser().getProfile())
            .map(UserProfile::getDisplayName)
            .orElse("Unknown");
        this.title = post.getTitle();
        this.description = post.getDescription();
        this.videoId = post.getVideoFile().getId();
        this.videoUrl = post.getVideoFile().getUrl();
//        this.thumbnailId = post.getThumbnailFile().getId(); // TODO - 썸네일 생성 처리 후 적
        // 개발용 null-safe
        this.thumbnailId = Optional.ofNullable(post.getThumbnailFile())
            .map(UploadedFile::getId)
            .orElse(null);
//        this.thumbnailUrl = post.getThumbnailFile().getUrl(); // TODO - 썸네일 생성 처리 후 적용
        this.thumbnailUrl = Optional.ofNullable(post.getThumbnailFile())
            .map(UploadedFile::getUrl)
            .orElse(null);
        // 개발용 null-safe
        this.streamingId = Optional.ofNullable(post.getStreamingFile())
            .map(UploadedFile::getId)
            .orElse(null);
        this.streamingUrl = Optional.ofNullable(post.getStreamingFile())
            .map(UploadedFile::getUrl)
            .orElse(null);
        this.tags = post.getTagList();
        this.likes = post.getLikes();
        this.comments = post.getComments();
        this.createdAt = post.getCreatedAt();
    }

    public void setVideoFileInfo(UploadedFile videoFileInfo) {
        this.videoId = videoFileInfo.getId();
        this.videoUrl = videoFileInfo.getUrl();
        this.createdAt = videoFileInfo.getUploadedAt();
    }

    public void setThumbnailFileInfo(UploadedFile thumbnailFileInfo) {
        this.thumbnailId = thumbnailFileInfo.getId();
        this.thumbnailUrl = thumbnailFileInfo.getUrl();
    }
}
