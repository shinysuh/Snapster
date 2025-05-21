package com.jenna.snapster.domain.file.video.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.core.s3.service.S3Service;
import com.jenna.snapster.domain.feed.user.service.UserFeedService;
import com.jenna.snapster.domain.file.constant.UploadedFileType;
import com.jenna.snapster.domain.file.uploaded.dto.UploadedFileDto;
import com.jenna.snapster.domain.file.uploaded.entity.UploadedFile;
import com.jenna.snapster.domain.file.uploaded.service.UploadedFileService;
import com.jenna.snapster.domain.file.util.ThumbnailGenerator;
import com.jenna.snapster.domain.file.video.dto.StreamingDto;
import com.jenna.snapster.domain.file.video.dto.VideoPostDto;
import com.jenna.snapster.domain.file.video.dto.VideoPostRequestDto;
import com.jenna.snapster.domain.file.video.entity.VideoPost;
import com.jenna.snapster.domain.file.video.repository.VideoPostRepository;
import com.jenna.snapster.domain.file.video.service.VideoPostService;
import com.jenna.snapster.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.File;

@Slf4j
@Service
@RequiredArgsConstructor
public class VideoPostServiceImpl implements VideoPostService {

    private final VideoPostRepository videoPostRepository;
    private final UploadedFileService uploadedFileService;
    private final S3Service s3Service;
    private final ThumbnailGenerator thumbnailGenerator;

    private final UserFeedService userFeedService;

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

        VideoPost uploadedVideo = videoPostRepository.save(new VideoPost(video));

        this.refreshUserFeed(currentUser.getId());

        return uploadedVideo;
    }

    private void refreshUserFeed(Long userId) {
        // 캐시 삭제
        String cacheEviction = userFeedService.evictUserFeedCache(userId, "public");
        log.info("########### eviction: {}", cacheEviction);
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


    @Transactional(rollbackFor = Exception.class)
    @Override
    public VideoPost saveStreamingFile(StreamingDto streamingDto) {
        log.info("\n ====================== Streaming File Save Method Called ======================\n userId: {}, url: {}", streamingDto.getUserId(), streamingDto.getUrl());

        String userId = streamingDto.getUserId();
        String url = streamingDto.getUrl();

        String videoUploadedAt = this.extractVideoUploadedAtFromUrl(url);

        UploadedFile videoInfo = uploadedFileService.getOneFileByUrlContaining(videoUploadedAt);

        UploadedFile streamingFileInfo = this.saveStreamingFileInfo(streamingDto);

        return this.updateVideoPost(videoInfo, streamingFileInfo);
    }

    @Override
    public VideoPost getOneByVideoFileId(Long videoFileId) {
        return videoPostRepository.findByVideoFileId(videoFileId)
            .orElseThrow(() -> new GlobalException(ErrorCode.NO_SUCH_FILE));
    }

    private VideoPost updateVideoPost(UploadedFile videoInfo, UploadedFile streamingFileInfo) {
        VideoPost videoPost = this.getOneByVideoFileId(videoInfo.getId());
        videoPost.setStreamingFile(streamingFileInfo);
        return videoPost;
    }

    private UploadedFile saveStreamingFileInfo(StreamingDto streamingDto) {
        String userIdStr = streamingDto.getUserId();
        String url = streamingDto.getUrl();
        Long userId = Long.parseLong(userIdStr);

        UploadedFileDto streamingFileInfo = UploadedFileDto.builder()
            .userId(userId)
            .fileName(this.extractFileName(url))
            .s3FilePath(this.extractS3FilePath(userIdStr, url))
            .url(url)
            .type(UploadedFileType.STREAMING.getType())
            .build();

        return uploadedFileService.saveFile(
            User.builder().id(userId).build(),
            streamingFileInfo
        );
    }

    private String extractVideoUploadedAtFromUrl(String url) {
        /*
            url 예시
            https://snapster-s3-bucket.s3.ap-northeast-2.amazonaws.com
            /user-10
            /streaming
            /1747842277993
            /1747842277993-image_picker_9909E39B-7846-4695-9856-EE1B608C228D-27663-0000005DCCF93B14trim.3BDBA36E-D531-4EA9-961B-CAC757A2928D.m3u8

            추출 타겟 : 1747842277993
         */
        String streamingDir = UploadedFileType.STREAMING.getType();
        int beginIndex = url.indexOf(streamingDir) + streamingDir.length() + 1;
        int endIndex = url.lastIndexOf("/");
        return url.substring(beginIndex, endIndex);
    }

    private String extractFileName(String url) {
        int beginIndex = url.lastIndexOf("/") + 1;
        return url.substring(beginIndex);
    }

    private String extractS3FilePath(String userId, String url) {
        userId = "user-" + userId;
        int beginIndex = url.indexOf(userId) + userId.length() + 1;
        return url.substring(beginIndex);
    }
}
