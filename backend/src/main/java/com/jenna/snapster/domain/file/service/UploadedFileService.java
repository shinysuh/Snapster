package com.jenna.snapster.domain.file.service;

import com.jenna.snapster.domain.file.dto.UploadedFileDto;
import com.jenna.snapster.domain.file.entity.UploadedFile;
import com.jenna.snapster.domain.user.entity.User;

import java.util.List;

public interface UploadedFileService {

    UploadedFile saveFile(User user, UploadedFileDto uploadedFile);

    List<UploadedFile> getAllFilesByUserId(Long userId);

    UploadedFile getOneFileByFileIdAndUserId(Long fileId, Long userId);

    void deleteFile(Long fileId, Long userId);
}
