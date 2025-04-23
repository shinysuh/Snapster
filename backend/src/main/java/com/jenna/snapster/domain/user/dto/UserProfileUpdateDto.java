package com.jenna.snapster.domain.user.dto;

import com.jenna.snapster.domain.user.entity.UserProfile;
import lombok.Data;

import java.time.LocalDate;

@Data
public class UserProfileUpdateDto {

    private String name;
    private String bio;
    private String link;
    private LocalDate birthday;
    private boolean hasAvatar;

    public void trimFields() {
        this.name = this.name.trim();
        this.bio = this.bio.trim();
        this.link = this.link.trim();
    }

    public void setUpdatedFields(UserProfile profile) {
        if (!this.name.equals(profile.getName())) {
            profile.setName(this.name);
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
        if (this.hasAvatar != profile.isHasAvatar()) {
            profile.setHasAvatar(this.hasAvatar);
        }
    }

//    public void validateUpdateFields() {
//        if (StringUtils.isEmpty(this.name)) {
//            throw new GlobalException(ErrorCode.USER_NAME_REQUIRED);
//        }
//    }

}
