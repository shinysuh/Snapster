package com.jenna.snapster.domain.user.dto;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDate;
import java.util.Objects;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserProfileDto {
    private Long userId;
    private String username;
    private String profileImageUrl;

    private String email;
    private String displayName;
    private String bio;
    private String link;
    private LocalDate birthday;
    private boolean hasProfileImage;

    public void trimFields() {
        this.displayName = this.displayName.trim();
        this.bio = this.bio.trim();
        this.link = this.link.trim();
    }

    public static UserProfileDto from(User user) {
        return UserProfileDto.builder()
            .userId(user.getId())
            .email(user.getEmail())
            .username(user.getUsername())
            .displayName(user.getProfile().getDisplayName())
            .bio(user.getProfile().getBio())
            .link(user.getProfile().getLink())
            .birthday(user.getProfile().getBirthday())
            .hasProfileImage(user.getProfile().isHasProfileImage())
            .profileImageUrl(user.getProfile().getProfileImageUrl())
            .build();
    }

    public void setUpdatedFields(User user, UserProfile profile) {
        this.validateUpdateFields(user);

        if (!this.username.equals(user.getUsername())) {
            user.setUsername(this.username);
        }
        if (!this.displayName.equals(profile.getDisplayName())) {
            profile.setDisplayName(this.displayName);
        }
        if (!this.bio.equals(profile.getBio())) {
            profile.setBio(this.bio);
        }
        if (!this.link.equals(profile.getLink())) {
            profile.setLink(this.link);
        }
    }

    public void validateUpdateFields(User user) {
        if (!Objects.equals(user.getId(), this.userId)) {
            throw new GlobalException(ErrorCode.INVALID_USER_ACCESS);
        }

        if (StringUtils.isEmpty(this.username)) {
            throw new GlobalException(ErrorCode.USER_NAME_REQUIRED);
        }
        if (StringUtils.isEmpty(this.displayName)) {
            throw new GlobalException(ErrorCode.DISPLAY_NAME_REQUIRED);
        }
    }
}
