package com.jenna.snapster.domain.user.dto;

import com.jenna.snapster.domain.user.entity.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UserResponseDto {
    private Long userId;
    private String email;
    private String username;

    public static UserResponseDto from(User user) {
        return UserResponseDto.builder()
            .userId(user.getId())
            .email(user.getEmail())
            .username(user.getUsername())
            .build();
    }
}
