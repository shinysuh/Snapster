package com.jenna.snapster.domain.file.video.dto;

import lombok.Data;

@Data
public class StreamingDto {

    private String userId;

    private String videoId;

    private String url;     // m3u8 S3 url
}
