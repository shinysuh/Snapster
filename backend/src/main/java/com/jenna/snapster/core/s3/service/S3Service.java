package com.jenna.snapster.core.s3.service;

import com.amazonaws.HttpMethod;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.GeneratePresignedUrlRequest;
import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.core.s3.PresignedUrlResponseDto;
import com.jenna.snapster.domain.file.uploaded.dto.UploadedFileDto;
import lombok.RequiredArgsConstructor;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.FileEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.File;
import java.util.Date;

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
    public PresignedUrlResponseDto generatePresignedUrl(Long userId, String fileName) {
        Date urlExpiration = new Date(System.currentTimeMillis() + expiration);
        String uploadFileName = this.generateUniqueFileName(userId, fileName);

        GeneratePresignedUrlRequest generatePresignedUrlRequest = new GeneratePresignedUrlRequest(bucketName, uploadFileName)
            .withMethod(HttpMethod.PUT)     // PUT 사용해서 업로드
            .withExpiration(urlExpiration);

        // 이미지 링크 클릭 시, 브라우저에서 보여주기 -> 다운로드 링크 X
        generatePresignedUrlRequest.addRequestParameter("response-content-disposition", "inline");

        UploadedFileDto uploadedFileDto = UploadedFileDto.builder()
            .userId(userId)
            .fileName(this.getOriginalFileName(fileName))
            .s3FilePath(uploadFileName)
            .url(this.getFileUrl(uploadFileName))
            .isPrivate(false)
            .build();

        return PresignedUrlResponseDto.builder()
            .presignedUrl(amazonS3.generatePresignedUrl(generatePresignedUrlRequest).toString())
            .uploadedFileInfo(uploadedFileDto)
            .build();
    }

    public UploadedFileDto uploadThumbnailToS3(Long userId, File thumbnail, String s3Path) {
        PresignedUrlResponseDto presignedUrlResponseDto = this.generatePresignedUrl(userId, s3Path);

        try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
            HttpPut putRequest = new HttpPut(presignedUrlResponseDto.getPresignedUrl());
            putRequest.setEntity(new FileEntity(thumbnail));
            putRequest.setHeader("Content-Type", ContentType.IMAGE_JPEG.getMimeType());
            httpClient.execute(putRequest);
        } catch (Exception e) {
            throw new GlobalException(ErrorCode.FAILED_TO_UPLOAD_THUMBNAIL);
        }
        return presignedUrlResponseDto.getUploadedFileInfo();
    }

    private String getFileUrl(String s3FilePath) {
        // publicUrl - 접근용
        return "https://" + bucketName + ".s3.amazonaws.com/" + s3FilePath;
    }

    private String getOriginalFileName(String fileName) {
        String originalFileName = "";
        int lastFileSeparatorIndex = fileName.lastIndexOf("/");

        if (lastFileSeparatorIndex >= 0) {
            originalFileName = fileName.substring(lastFileSeparatorIndex + 1);
        }
        return originalFileName;
    }

    private String generateUniqueFileName(Long userId, String fileName) {
        StringBuilder sb = new StringBuilder();

        sb.append("user-")
            .append(userId)
            .append("/");

        this.setFolderPathAndFileName(sb, fileName);
        return sb.toString();
    }

    private void setFolderPathAndFileName(StringBuilder sb, String fileName) {
        String folderPath;
        String originalFileName = fileName;

        int lastFileSeparatorIndex = fileName.lastIndexOf("/");

        // fileName에 폴더명이 있으면, 사용자 폴더 생성 다음에 넣어주기
        if (lastFileSeparatorIndex >= 0) {
            folderPath = fileName.substring(0, lastFileSeparatorIndex);
            originalFileName = fileName.substring(lastFileSeparatorIndex + 1);

            sb.append(folderPath)
                .append("/");
        }

        sb.append(System.currentTimeMillis())
            .append("-")
            .append(originalFileName);
    }
}
