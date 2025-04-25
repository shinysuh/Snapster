package com.jenna.snapster.core.s3;

import com.jenna.snapster.domain.file.dto.UploadedFileDto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PresignedUrlResponseDto {

    private String presignedUrl;

    private UploadedFileDto uploadedFileInfo;
}
