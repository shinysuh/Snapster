package com.jenna.snapster.domain.file.service.impl;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.file.entity.UploadedFile;
import com.jenna.snapster.domain.file.repository.UploadedFileRepository;
import com.jenna.snapster.domain.file.service.UploadedFileService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class UploadedFileServiceImpl implements UploadedFileService {

    private final UploadedFileRepository uploadedFileRepository;

    @Override
    public UploadedFile saveFile(UploadedFile file) {
        return uploadedFileRepository.save(file);
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
}
