package com.jenna.snapster.domain.file.uploaded.service;

import com.jenna.snapster.domain.file.uploaded.dto.UploadedFileDto;
import com.jenna.snapster.domain.file.uploaded.entity.UploadedFile;
import com.jenna.snapster.domain.file.video.dto.StreamingDto;
import com.jenna.snapster.domain.user.entity.User;

import java.util.List;

public interface UploadedFileService {

    UploadedFile saveFile(User currentUser, UploadedFileDto uploadedFile);

    void saveStreamingFile(StreamingDto streamingDto);

    List<UploadedFile> getAllFilesByUserId(Long userId);

    UploadedFile getOneFileByFileIdAndUserId(Long fileId, Long userId);

    void updateFileAsDeletedByUrl(User currentUser, UploadedFileDto uploadedFileDto);

    void updateFileAsDeletedByFileIdAndUserId(Long fileId, Long userId);
}
