package com.jenna.snapster.domain.user.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
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
