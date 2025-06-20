package com.jenna.snapster.domain.user.repository;

import com.jenna.snapster.domain.user.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByOauthProviderAndOauthId(String provider, String oauthId);

    List<User> findAllByIdIn(List<Long> userIds);

    @Query("SELECT u FROM User u WHERE u.id <> :userId")
    List<User> findAllExceptCurrentUser(@Param("userId") Long userId);

//    @Query("SELECT u FROM User u WHERE u.id <> :userId")
//    Page<User> findAllExceptUserId(@Param("userId") Long userId, Pageable pageable);
}
