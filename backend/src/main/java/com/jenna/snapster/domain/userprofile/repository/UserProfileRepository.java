package com.jenna.snapster.domain.userprofile.repository;

import com.jenna.snapster.domain.userprofile.entity.UserProfile;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserProfileRepository extends JpaRepository<UserProfile, Long> {

}
