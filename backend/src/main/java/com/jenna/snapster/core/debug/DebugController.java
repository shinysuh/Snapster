package com.jenna.snapster.core.debug;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/api/debug")
public class DebugController {

    @GetMapping("/headers")
    public ResponseEntity<?> headers(HttpServletRequest request) {
        log.info("\n\n ------------- X-Forwarded-Proto: {} ------------- \n\n", request.getHeader("X-Forwarded-Proto"));
        return ResponseEntity.ok().build();
    }
}
