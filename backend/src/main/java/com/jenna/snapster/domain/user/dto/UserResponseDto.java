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
    private String email;
    private String username;

    private String name;
    private String bio;
    private String link;
    private LocalDate birthday;
    private boolean hasProfileImage;

    public static UserResponseDto from(User user) {
        return UserResponseDto.builder()
            .userId(user.getId())
            .email(user.getEmail())
            .username(user.getUsername())
            .name(user.getProfile().getName())
            .bio(user.getProfile().getBio())
            .link(user.getProfile().getLink())
            .birthday(user.getProfile().getBirthday())
            .hasProfileImage(user.getProfile().isHasProfileImage())
            .build();
    }
}
