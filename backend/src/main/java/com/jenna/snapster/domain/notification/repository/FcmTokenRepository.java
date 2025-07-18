package com.jenna.snapster.domain.notification.repository;

import com.jenna.snapster.domain.notification.entity.FcmToken;
import com.jenna.snapster.domain.notification.entity.FcmTokenId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FcmTokenRepository extends JpaRepository<FcmToken, FcmTokenId> {

    List<FcmToken> findByIdUserId(Long userId);

    // 토큰 기준 삭제
    void deleteByIdFcmToken(String fcmToken);

    // 사용자/토큰 기준 삭제
    void deleteByIdUserIdAndIdFcmToken(Long userId, String token);
}
