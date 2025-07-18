package com.jenna.snapster.domain.file.uploaded.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.file.uploaded.dto.UploadedFileDto;
import com.jenna.snapster.domain.file.uploaded.entity.UploadedFile;
import com.jenna.snapster.domain.file.uploaded.repository.UploadedFileRepository;
import com.jenna.snapster.domain.file.uploaded.service.UploadedFileService;
import com.jenna.snapster.domain.user.entity.User;
import com.jenna.snapster.domain.user.entity.UserProfile;
import com.jenna.snapster.domain.user.service.UserService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;

@Slf4j
@Service
@RequiredArgsConstructor
public class UploadedFileServiceImpl implements UploadedFileService {

    private final UploadedFileRepository uploadedFileRepository;
    private final UserService userService;

    @Transactional(rollbackFor = Exception.class)
    @Override
    public UploadedFile saveFile(User currentUser, UploadedFileDto uploadedFile) {
        this.checkAndUpdateProfile(currentUser.getProfile(), uploadedFile);
        return uploadedFileRepository.save(new UploadedFile(uploadedFile));
    }

    @Transactional(readOnly = true)
    @Override
    public List<UploadedFile> getAllFilesByUserId(Long userId) {
        return uploadedFileRepository.findAllByUserIdAndIsDeletedFalseOrderByUploadedAtDesc(userId);
    }

    @Override
    public UploadedFile getOneFileByFileIdAndUserId(Long fileId, Long userId) {
        return uploadedFileRepository.findByIdAndUserIdAndIsDeletedFalse(fileId, userId)
            .orElseThrow(() -> new GlobalException(ErrorCode.NO_SUCH_FILE));
    }

    @Override
    public UploadedFile getOneFileByUrlContaining(String keyword) {
        return uploadedFileRepository.findByUrlContaining(keyword)
            .orElseThrow(() -> new GlobalException(ErrorCode.NO_SUCH_FILE));
    }

    @Transactional(rollbackFor = Exception.class)
    @Override
    public void updateFileAsDeletedByUrl(User currentUser, UploadedFileDto uploadedFileDto) {
        String url = uploadedFileDto.getUrl();
        UploadedFile file = this.getUploadedFileByUrl(url);
        if (this.validateFileToDelete(currentUser, file)) return;

        file.markDeleted();
        userService.updateUserProfileImage(currentUser.getProfile(), false, "");
    }

    @Override
    public void updateFileAsDeletedByFileIdAndUserId(Long fileId, Long userId) {
        UploadedFile file = this.getOneFileByFileIdAndUserId(fileId, userId);
        file.markDeleted();
    }

    private void checkAndUpdateProfile(UserProfile profile, UploadedFileDto uploadedFile) {
        if (uploadedFile.getS3FilePath().contains("/profile/")) {
            userService.updateUserProfileImage(profile, true, uploadedFile.getUrl());
        }
    }

    private UploadedFile getUploadedFileByUrl(String url) {
        return uploadedFileRepository.findByUrl(url)
            .orElseThrow(() -> new GlobalException(ErrorCode.NO_SUCH_FILE));
    }

    private boolean validateFileToDelete(User currentUser, UploadedFile file) {
        if (!Objects.equals(currentUser.getId(), file.getUserId())) {
            throw new GlobalException(ErrorCode.FILE_DELETE_ACTION_UNAUTHORIZED);
        }
        return !file.isDeleted() && currentUser.getProfile().hasProfile();
    }
}
