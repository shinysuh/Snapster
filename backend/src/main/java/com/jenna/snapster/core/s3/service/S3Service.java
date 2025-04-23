package com.jenna.snapster.core.s3.service;

import com.amazonaws.HttpMethod;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import lombok.RequiredArgsConstructor;
import org.joda.time.DateTime;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.net.URL;
import java.util.Date;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class S3Service {

    private final AmazonS3 amazonS3;

    @Value("${aws.s3.bucket-name}")
    private String bucketName;

    @Value("${aws.s3.expiration}")
    private Long expiration;

    /**
     * Pre-signed URL 생성
     *
     * @param userId   업로드 사용자 ID
     * @param fileName 업로드할 파일명
     * @return pre-signed URL
     */
    public URL generatePresignedUrl(Long userId, String fileName) {
        Date urlExpiration = new Date(System.currentTimeMillis() + expiration);
        String uploadFileName = this.generateUniqueFileName(userId, fileName);

        GeneratePresignedUrlRequest generatePresignedUrlRequest = new GeneratePresignedUrlRequest(bucketName, uploadFileName)
            .withMethod(HttpMethod.PUT)     // PUT 사용해서 업로드
            .withExpiration(urlExpiration);

        return amazonS3.generatePresignedUrl(generatePresignedUrlRequest);
    }

    private String generateUniqueFileName(Long userId, String fileName) {
        StringBuilder sb = new StringBuilder();
        sb.append("user-")
            .append(userId)
            .append("/")
            .append(UUID.randomUUID())
            .append("-")
            .append(DateTime.now().getMillis())
            .append("-")
            .append(fileName);

        return sb.toString();
    }
}
