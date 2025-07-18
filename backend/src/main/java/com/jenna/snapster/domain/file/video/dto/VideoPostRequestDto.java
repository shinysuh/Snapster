package com.jenna.snapster.domain.file.video.dto;

import com.jenna.snapster.domain.file.uploaded.dto.UploadedFileDto;
import lombok.Data;

@Data
public class VideoPostRequestDto {

    private VideoPostDto videoInfo;

    private UploadedFileDto uploadedFileInfo;
}
