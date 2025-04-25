package com.jenna.snapster.domain.file.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.file.dto.UploadedFileDto;
import com.jenna.snapster.domain.file.entity.UploadedFile;
import com.jenna.snapster.domain.file.repository.UploadedFileRepository;
import com.jenna.snapster.domain.file.service.UploadedFileService;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;
import com.jenna.snapster.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UploadedFileServiceImpl implements UploadedFileService {

    private final UploadedFileRepository uploadedFileRepository;
    private final UserService userService;

    @Override
    public UploadedFile saveFile(User user, UploadedFileDto uploadedFile) {
        this.checkAndUpdateProfile(user.getProfile(), uploadedFile);
        return uploadedFileRepository.save(new UploadedFile(uploadedFile));
    }

    @Override
    public List<UploadedFile> getAllFilesByUserId(Long userId) {
        return uploadedFileRepository.findAllByUserIdAndIsDeletedFalse(userId);
    }

    @Override
    public UploadedFile getOneFileByFileIdAndUserId(Long fileId, Long userId) {
        return uploadedFileRepository.findAllByIdAndUserIdAndIsDeletedFalse(fileId, userId)
            .orElseThrow(() -> new GlobalException(ErrorCode.NO_SUCH_FILE));
    }

    @Override
    public void deleteFile(Long fileId, Long userId) {
        UploadedFile file = this.getOneFileByFileIdAndUserId(fileId, userId);
        file.markDeleted();
    }

    private void checkAndUpdateProfile(UserProfile profile, UploadedFileDto uploadedFile) {
        if (uploadedFile.getS3FilePath().contains("/profiles/")) {
            userService.updateUserProfileImage(profile, true, uploadedFile.getUrl());
        }
    }
}
