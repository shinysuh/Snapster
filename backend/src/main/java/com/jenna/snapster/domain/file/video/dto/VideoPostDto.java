package com.jenna.snapster.domain.file.video.dto;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.jenna.snapster.domain.file.uploaded.entity.UploadedFile;
import com.jenna.snapster.domain.file.video.entity.VideoPost;
import com.jenna.snapster.domain.user.entity.UserProfile;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class VideoPostDto {

    private Long id;

    private Long userId;

    private String userDisplayName;

    private String userProfileImageUrl;

    private String title;

    private String description;

    private Long videoId;

    private String videoUrl;

    private Long thumbnailId;

    private String thumbnailUrl;

    @JsonIgnore
    private Long streamingId;

    private String streamingUrl;

    private List<String> tags;

    private Long likes;

    private Long comments;

    private LocalDateTime createdAt;

    public VideoPostDto(VideoPost post) {
        this.id = post.getId();
        this.userId = post.getUser().getId();

        UserProfile profile = post.getUser().getProfile();
        this.userDisplayName = profile != null ? profile.getDisplayName() : "Unknown";
        this.userProfileImageUrl = profile != null && profile.hasProfile() ? profile.getProfileImageUrl() : "";

        this.title = post.getTitle();
        this.description = post.getDescription();
        this.videoId = post.getVideoFile().getId();
        this.videoUrl = post.getVideoFile().getUrl();

//        this.thumbnailId = post.getThumbnailFile().getId(); // TODO - 썸네일 생성 처리 후 적
//        this.thumbnailUrl = post.getThumbnailFile().getUrl(); // TODO - 썸네일 생성 처리 후 적
        // 개발용 null-safe
        UploadedFile thumbnailFile = post.getThumbnailFile();
        this.thumbnailId = thumbnailFile != null ? thumbnailFile.getId() : null;
        this.thumbnailUrl = thumbnailFile != null ? thumbnailFile.getUrl() : null;

        // 개발용 null-safe
        UploadedFile streamingFile = post.getStreamingFile();
        this.streamingId = streamingFile != null ? streamingFile.getId() : null;
        this.streamingUrl = streamingFile != null ? streamingFile.getUrl() : null;

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
