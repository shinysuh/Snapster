package com.jenna.snapster.domain.file.util;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

@Slf4j
@Component
public class ThumbnailGenerator {

    public File generateThumbnail(String inputUrl, String outputFilePath) {
        try {
            int rotation = this.getRotation(inputUrl);
            Process process = this.getProcess(inputUrl, outputFilePath, rotation);

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

    private Process getProcess(String inputUrl, String outputFilePath, int rotation) throws IOException {
        String vfFilter = "scale=320:-1";
        // 회전값에 따라 transpose 필터 추가
        if (rotation == 90) {
            vfFilter = "transpose=1," + vfFilter;  // 90도 시계방향 회전
        } else if (rotation == 180) {
            vfFilter = "transpose=2,transpose=2," + vfFilter; // 180도 회전
        } else if (rotation == 270) {
            vfFilter = "transpose=2," + vfFilter;  // 270도 (90도 반시계) 회전
        }

        ProcessBuilder pb = new ProcessBuilder(
            "ffmpeg",
            "-y",
            "-i",
            inputUrl,
            "-ss",
            "00:00:00.010",
            "-vframes",
            "1",
            "-vf",
            vfFilter,
            outputFilePath
        );

        pb.redirectErrorStream(true);
        return pb.start();
    }

    private int getRotation(String inputUrl) throws Exception {
        ProcessBuilder pb = new ProcessBuilder(
            "ffprobe",
            "-v", "error",
            "-select_streams", "v:0",
            "-show_entries", "stream_tags=rotate",
            "-of", "default=nw=1:nk=1",
            inputUrl
        );

        pb.redirectErrorStream(true);
        Process process = pb.start();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()))) {
            String line = reader.readLine();
            process.waitFor();  // 프로세스 종료 대기
            if (line != null && !line.isEmpty()) {
                return Integer.parseInt(line.trim());
            }
        }
        return 0; // 회전 정보 없으면 0 반환
    }

}
