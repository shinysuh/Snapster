package com.jenna.snapster.domain.file.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum UploadedFileType {

    PROFILE("profile"),
    VIDEO("video"),
    THUMBNAIL("thumbnail"),
    STORY("story"),
    ;

    private final String type;
}
