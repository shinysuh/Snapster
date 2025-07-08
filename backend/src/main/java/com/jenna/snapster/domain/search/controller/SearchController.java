package com.jenna.snapster.domain.search.controller;

import com.jenna.snapster.domain.search.service.VideoSearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/search")
public class SearchController {

    private final VideoSearchService videoSearchService;

    @GetMapping("")
    public ResponseEntity<?> search(@RequestParam String keyword) throws IOException {
        return ResponseEntity.ok(videoSearchService.searchByKeyword(keyword));
    }

    @GetMapping("/prefix")
    public ResponseEntity<?> searchByKeywordPrefix(@RequestParam String keyword) throws IOException {
        return ResponseEntity.ok(videoSearchService.searchByKeywordPrefix(keyword));
    }
}
