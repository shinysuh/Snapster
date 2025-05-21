package com.jenna.snapster.domain.file.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum UploadedFileType {

    PROFILE("profile"),
    VIDEO("video"),
    THUMBNAIL("thumbnail"),
    STREAMING("streaming"),
    STORY("story"),
    ;

    private final String type;
}
