package com.jenna.snapster.domain.file.video.service.impl;

import com.jenna.snapster.domain.file.uploaded.entity.UploadedFile;
import com.jenna.snapster.domain.file.uploaded.service.UploadedFileService;
import com.jenna.snapster.domain.file.video.dto.VideoPostDto;
import com.jenna.snapster.domain.file.video.dto.VideoPostRequestDto;
import com.jenna.snapster.domain.file.video.entity.VideoPost;
import com.jenna.snapster.domain.file.video.repository.VideoPostRepository;
import com.jenna.snapster.domain.file.video.service.VideoPostService;
import com.jenna.snapster.domain.user.entity.User;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class VideoPostServiceImpl implements VideoPostService {

    private final VideoPostRepository videoPostRepository;
    private final UploadedFileService uploadedFileService;

    @Transactional(rollbackFor = Exception.class)
    @Override
    public VideoPost saveVideoPostAndUploadedFileInfo(User currentUser, VideoPostRequestDto videoPostRequestDto) {
        VideoPostDto video = videoPostRequestDto.getVideoInfo();
        UploadedFile uploadedFile = uploadedFileService.saveFile(currentUser, videoPostRequestDto.getUploadedFileInfo());

        // videoPost 내 uploaded video 정보 세팅
        video.setVideoId(uploadedFile.getId());
        video.setVideoUrl(uploadedFile.getUrl());
        video.setCreatedAt(uploadedFile.getUploadedAt());

        // TODO - 썸네일 생성/저장, 썸네일 ID 세팅 로직

        return videoPostRepository.save(new VideoPost(video));
    }
}
