package com.jenna.snapster.domain.file.controller;

import com.jenna.snapster.core.security.annotation.CurrentUser;
import com.jenna.snapster.core.security.util.CustomUserDetails;
import com.jenna.snapster.domain.file.uploaded.dto.UploadedFileDto;
import com.jenna.snapster.domain.file.uploaded.service.UploadedFileService;
import com.jenna.snapster.domain.file.video.dto.VideoPostRequestDto;
import com.jenna.snapster.domain.file.video.service.VideoPostService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/file")
public class FileController {

    private final UploadedFileService uploadedFileService;
    private final VideoPostService videoPostService;

    @PostMapping("/upload")
    public ResponseEntity<?> saveUploadedFileInfo(@CurrentUser CustomUserDetails currentUser,
                                                  @RequestBody UploadedFileDto uploadedFileDto) {
        return ResponseEntity.ok(uploadedFileService.saveFile(currentUser.getUser(), uploadedFileDto));
    }

    @PostMapping("/video")
    public ResponseEntity<?> saveVideoPostAndUploadedFileInfo(@CurrentUser CustomUserDetails currentUser,
                                                              @RequestBody VideoPostRequestDto videoPostRequestDto) {
        return ResponseEntity.ok(videoPostService.saveVideoPostAndUploadedFileInfo(currentUser.getUser(), videoPostRequestDto));
    }

    @PutMapping("/delete")
    public ResponseEntity<?> updateFileAsDeleted(@CurrentUser CustomUserDetails currentUser,
                                                 @RequestBody UploadedFileDto uploadedFileDto) {
        uploadedFileService.updateFileAsDeletedByUrl(currentUser.getUser(), uploadedFileDto);
        return ResponseEntity.ok().build();
    }
}
