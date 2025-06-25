package com.jenna.snapster.domain.user.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;
import org.apache.commons.lang3.StringUtils;

import java.time.LocalDate;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "user_profiles")
public class UserProfile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne
    @MapsId
    @JsonIgnore  // 순환 방지: Profile → User 직렬화 막기
    @ToString.Exclude   // 순환 방지
    @JoinColumn(name = "user_id")
    private User user;

    private String displayName;
    private String bio;
    private String link;
    private LocalDate birthday;
    private boolean hasProfileImage;
    private String profileImageUrl;

    public boolean hasProfile() {
        return hasProfileImage && StringUtils.isNotEmpty(profileImageUrl);
    }
}
