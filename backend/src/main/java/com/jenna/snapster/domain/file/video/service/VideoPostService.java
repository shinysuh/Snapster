package com.jenna.snapster.domain.file.video.service;

import com.jenna.snapster.domain.file.video.dto.StreamingDto;
import com.jenna.snapster.domain.file.video.dto.VideoPostRequestDto;
import com.jenna.snapster.domain.file.video.dto.VideoSaveDto;
import com.jenna.snapster.domain.file.video.entity.VideoPost;
import com.jenna.snapster.domain.user.entity.User;

public interface VideoPostService {

    VideoSaveDto saveVideoPostAndUploadedFileInfo(User currentUser, VideoPostRequestDto videoPostRequestDto);

    VideoPost saveStreamingFile(StreamingDto streamingDto);

    VideoPost getOneByVideoFileId(Long videoFileId);
}
