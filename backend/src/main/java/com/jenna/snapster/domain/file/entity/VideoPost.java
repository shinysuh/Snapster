package com.jenna.snapster.domain.file.entity;

import com.jenna.snapster.domain.user.entity.User;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

@Entity
@Table(name = "video_posts")
@Getter
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

    private String fileUrl;

    private String thumbnailUrl;

    private Long likes;

    private Long comments;

    private LocalDateTime createdAt;

    private String tags;

    @Transient
    private List<String> tagList;

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
            this.tags = String.join(",", tagList);
        }
    }
}
