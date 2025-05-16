package com.jenna.snapster.domain.file.util;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;

@Slf4j
@Component
public class ThumbnailGenerator {

    public File generateThumbnail(String inputUrl, String outputFilePath) {
        try {
            ProcessBuilder pb = new ProcessBuilder(
                "ffmpeg",
                "-y",
                "-i",
                inputUrl,
                "-ss",
                "00:00:01.000",
                "-vframes",
                "1",
                "-vf",
                "scale=320:-1",
                outputFilePath
            );

            pb.redirectErrorStream(true);
            Process process = pb.start();

            try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    System.out.println("[ffmpeg] " + line);
                }
            }

            int exitCode = process.waitFor();
            if (exitCode != 0) {
                throw new RuntimeException(String.format(":: exit code :: %d", exitCode));
            }

            return new File(outputFilePath);
        } catch (Exception e) {
            log.error("썸네일 생성 실패:", e);
            throw new GlobalException(ErrorCode.FAILED_TO_CREAT_THUMBNAIL, e.getMessage());
        }
    }
}
