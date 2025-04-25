package com.jenna.snapster.domain.user.dto;

import com.jenna.snapster.domain.user.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponseDto {
    private Long userId;
    private String username;
    private String profileImageUrl;

    private String email;
    private String displayName;
    private String bio;
    private String link;
    private LocalDate birthday;
    private boolean hasProfileImage;

    public static UserResponseDto from(User user) {
        return UserResponseDto.builder()
            .userId(user.getId())
            .email(user.getEmail())
            .username(user.getUsername())
            .displayName(user.getProfile().getDisplayName())
            .bio(user.getProfile().getBio())
            .link(user.getProfile().getLink())
            .birthday(user.getProfile().getBirthday())
            .hasProfileImage(user.getProfile().isHasProfileImage())
            .build();
    }
}
