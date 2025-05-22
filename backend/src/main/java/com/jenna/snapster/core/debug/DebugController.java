package com.jenna.snapster.core.debug;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
public class DebugController {

    @GetMapping("/api/debug/headers")
    public void headers(HttpServletRequest request) {
        log.info("X-Forwarded-Proto: {}", request.getHeader("X-Forwarded-Proto"));
    }
}
