package com.jenna.snapster.domain.search.controller;

import com.jenna.snapster.domain.search.dto.SearchRequestDto;
import com.jenna.snapster.domain.search.service.VideoSearchService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/search")
public class SearchController {

    private final VideoSearchService videoSearchService;

    @GetMapping("")
    public ResponseEntity<?> searchByKeyword(@RequestParam String keyword) throws IOException {
        return ResponseEntity.ok(videoSearchService.searchByKeyword(keyword));
    }

    @GetMapping("/prefix")
    public ResponseEntity<?> searchByKeywordPrefix(@RequestParam String keyword) throws IOException {
        return ResponseEntity.ok(videoSearchService.searchByKeywordPrefix(keyword));
    }

    @PostMapping("")
    public ResponseEntity<?> searchByKeywordPrefixWithPaging(@RequestBody SearchRequestDto searchRequest) throws IOException {
        return ResponseEntity.ok(videoSearchService.searchByKeywordPrefixWithPaging(searchRequest));
    }
}
