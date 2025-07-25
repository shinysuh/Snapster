package com.jenna.snapster.domain.file.uploaded.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UploadedFileDto {

    private Long userId;
    private String fileName;
    private String s3FilePath;
    private String url;
    private String type;

    @JsonProperty("isPrivate")
    private boolean isPrivate;

}
