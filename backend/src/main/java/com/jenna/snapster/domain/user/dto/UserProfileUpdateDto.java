package com.jenna.snapster.domain.user.dto;

import com.jenna.snapster.domain.user.entity.UserProfile;
import lombok.Data;

import java.time.LocalDate;

@Data
public class UserProfileUpdateDto {

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

    public void setUpdatedFields(UserProfile profile) {
        if (!this.displayName.equals(profile.getDisplayName())) {
            profile.setDisplayName(this.displayName);
        }
        if (!this.bio.equals(profile.getBio())) {
            profile.setBio(this.bio);
        }
        if (!this.link.equals(profile.getLink())) {
            profile.setLink(this.link);
        }
        if (this.birthday != profile.getBirthday()) {
            profile.setBirthday(this.birthday);
        }
        if (this.hasProfileImage != profile.isHasProfileImage()) {
            profile.setHasProfileImage(this.hasProfileImage);
        }
    }

//    public void validateUpdateFields() {
//        if (StringUtils.isEmpty(this.name)) {
//            throw new GlobalException(ErrorCode.USER_NAME_REQUIRED);
//        }
//    }

}
