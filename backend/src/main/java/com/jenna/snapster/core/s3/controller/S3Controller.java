package com.jenna.snapster.core.s3.controller;

import com.jenna.snapster.core.s3.service.S3Service;
import com.jenna.snapster.core.security.annotation.CurrentUser;
import com.jenna.snapster.core.security.util.CustomUserDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/s3")
public class S3Controller {

    private final S3Service s3Service;

    /**
     * Pre-signed URL 발급 API
     *
     * @param customUserDetails 업로드 사용자
     * @param fileName          업로드 파일명
     * @return pre-signed URL
     */
    @GetMapping("/presigned-url")
    public String getPresignedUrl(@CurrentUser CustomUserDetails customUserDetails,
                                  @RequestParam String fileName) {
        return s3Service.generatePresignedUrl(customUserDetails.getUser().getId(), fileName).toString();
    }
}
