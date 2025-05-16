package com.jenna.snapster.domain.file.video.service.impl;

import com.jenna.snapster.core.s3.service.S3Service;
import com.jenna.snapster.domain.file.constant.UploadedFileType;
import com.jenna.snapster.domain.file.uploaded.dto.UploadedFileDto;
import com.jenna.snapster.domain.file.uploaded.entity.UploadedFile;
import com.jenna.snapster.domain.file.uploaded.service.UploadedFileService;
import com.jenna.snapster.domain.file.util.ThumbnailGenerator;
import com.jenna.snapster.domain.file.video.dto.VideoPostDto;
import com.jenna.snapster.domain.file.video.dto.VideoPostRequestDto;
import com.jenna.snapster.domain.file.video.entity.VideoPost;
import com.jenna.snapster.domain.file.video.repository.VideoPostRepository;
import com.jenna.snapster.domain.file.video.service.VideoPostService;
import com.jenna.snapster.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;

@Service
@RequiredArgsConstructor
public class VideoPostServiceImpl implements VideoPostService {

    private final VideoPostRepository videoPostRepository;
    private final UploadedFileService uploadedFileService;
    private final S3Service s3Service;
    private final ThumbnailGenerator thumbnailGenerator;

    @Transactional(rollbackFor = Exception.class)
    @Override
    public VideoPost saveVideoPostAndUploadedFileInfo(User currentUser, VideoPostRequestDto videoPostRequestDto) {
        UploadedFile uploadedFile = uploadedFileService.saveFile(currentUser, videoPostRequestDto.getUploadedFileInfo());

        VideoPostDto video = videoPostRequestDto.getVideoInfo();
        // videoPost 내 uploaded video 정보 세팅
        video.setVideoFileInfo(uploadedFile);

        // 썸네일 생성/저장, videoPost 내 썸네일 정보 세팅
        UploadedFile uploadedThumbnail = this.createAndSavaThumbnail(currentUser, uploadedFile);
        video.setThumbnailFileInfo(uploadedThumbnail);

        return videoPostRepository.save(new VideoPost(video));
    }

    private UploadedFile createAndSavaThumbnail(User currentUser, UploadedFile uploadedVideoFile) {
        // 썸네일 생성 - ffmpeg
        File thumbnailFile = this.generateThumbnail(uploadedVideoFile);
        // S3 업로드 && DB 저장
        return this.saveThumbnailInfo(currentUser, thumbnailFile, this.getThumbnailFilePath(uploadedVideoFile.getId()));
    }

    private File generateThumbnail(UploadedFile uploadedFile) {
        // 썸네일 생성 - ffmpeg
        String tmpPath = "/tmp/thumbnail-" + uploadedFile.getId() + ".jpg";
        return thumbnailGenerator.generateThumbnail(uploadedFile.getUrl(), tmpPath);
    }

    private UploadedFile saveThumbnailInfo(User currentUser, File thumbnailFile, String s3Path) {
        // S3 업로드
        UploadedFileDto thumbnailInfo = s3Service.uploadThumbnailToS3(currentUser.getId(), thumbnailFile, s3Path);
        thumbnailInfo.setType(UploadedFileType.THUMBNAIL.getType());
        // DB 저장
        return uploadedFileService.saveFile(currentUser, thumbnailInfo);
    }

    private String getThumbnailFilePath(Long uploadedVideoFileId) {
        StringBuilder sb = new StringBuilder();
        sb.append(UploadedFileType.THUMBNAIL.getType())
            .append("/")
            .append(UploadedFileType.THUMBNAIL.getType())
            .append("-")
            .append(UploadedFileType.VIDEO.getType())
            .append("-")
            .append(uploadedVideoFileId)
            .append(".jpg");
        return sb.toString();
    }
}
