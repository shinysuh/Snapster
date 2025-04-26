package com.jenna.snapster.domain.user.dto;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;
import lombok.Data;
import org.apache.commons.lang3.StringUtils;

@Data
public class UserProfileUpdateDto {

    private String username;
    private String displayName;
    private String bio;
    private String link;

    public void trimFields() {
        this.displayName = this.displayName.trim();
        this.bio = this.bio.trim();
        this.link = this.link.trim();
    }

    public void setUpdatedFields(User user, UserProfile profile) {
        this.validateUpdateFields();

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

    public void validateUpdateFields() {
        if (StringUtils.isEmpty(this.username)) {
            throw new GlobalException(ErrorCode.USER_NAME_REQUIRED);
        }
        if (StringUtils.isEmpty(this.displayName)) {
            throw new GlobalException(ErrorCode.DISPLAY_NAME_REQUIRED);
        }
    }

}
