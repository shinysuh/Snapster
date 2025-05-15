package com.jenna.snapster.domain.file.dto;

import com.jenna.snapster.domain.file.entity.VideoPost;
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

    private String fileUrl;

    private String thumbnailUrl;

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
        this.fileUrl = post.getVideoFile().getUrl();
        this.thumbnailUrl = post.getThumbnailFile().getUrl();
        this.tags = post.getTagList();
        this.likes = post.getLikes();
        this.comments = post.getComments();
        this.createdAt = post.getCreatedAt();
    }
}
