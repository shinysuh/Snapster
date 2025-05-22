package com.jenna.snapster.core.debug;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@Slf4j
@RestController
@RequestMapping("/api/debug")
public class DebugController {

    @GetMapping("/headers")
    public ResponseEntity<?> headers(HttpServletRequest request) {
        log.info("X-Forwarded-Proto: {}", request.getHeader("X-Forwarded-Proto"));
        return ResponseEntity.ok(
            Map.of(
                "X-Forwarded-Proto", request.getHeader("X-Forwarded-Proto")
            )
        );
    }
}
