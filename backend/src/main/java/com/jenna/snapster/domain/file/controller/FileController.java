package com.jenna.snapster.domain.file.controller;

import com.jenna.snapster.domain.file.dto.UploadedFileDto;
import com.jenna.snapster.domain.file.service.UploadedFileService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/file")
public class FileController {

    private final UploadedFileService uploadedFileService;

    @PostMapping("")
    public ResponseEntity<?> saveUploadedFileInfo(@RequestBody UploadedFileDto uploadedFileDto) {
        return ResponseEntity.ok(uploadedFileService.saveFile(uploadedFileDto));
    }
}
