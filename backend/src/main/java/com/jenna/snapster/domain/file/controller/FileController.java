package com.jenna.snapster.domain.file.controller;

import com.jenna.snapster.domain.file.service.UploadedFileService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/file")
public class FileController {

    private final UploadedFileService uploadedFileService;





}
