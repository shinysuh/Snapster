package com.jenna.snapster.domain.search.service;

import co.elastic.clients.elasticsearch.ElasticsearchClient;
import co.elastic.clients.elasticsearch._types.SortOrder;
import co.elastic.clients.elasticsearch._types.query_dsl.TextQueryType;
import co.elastic.clients.elasticsearch.core.SearchRequest;
import co.elastic.clients.elasticsearch.core.SearchResponse;
import co.elastic.clients.json.JsonData;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jenna.snapster.domain.file.video.dto.VideoPostDto;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class VideoSearchService {

    private final ElasticsearchClient esClient;
    private final ObjectMapper objectMapper;

    @Value("${elasticsearch.index.video}")
    private String videoIndex;

    public List<VideoPostDto> searchByKeyword(String keyword) throws IOException {
        SearchResponse<JsonData> response = esClient.search(
            new SearchRequest.Builder()
                .index(videoIndex)
//                .size(100)
                .query(q -> q
                    .multiMatch(mm -> mm
                        .query(keyword)
                        .fields("title^3", "tags^2", "description")  // 부스트 주기
                        .type(TextQueryType.BestFields)                        // 가장 높은 스코어 하나 기준
                        .tieBreaker(0.3)
                    )
                )
                .build(),
            JsonData.class
        );

        return response.hits().hits().stream()
            .map(hit -> {
                Object sourceObj = hit.source().to(Map.class);
                return objectMapper.convertValue(sourceObj, VideoPostDto.class);
            })
            .toList();
    }

    public List<VideoPostDto> searchByKeywordPrefix(String keyword) throws IOException {
        SearchRequest.Builder searchBuilder = new SearchRequest.Builder()
            .index(videoIndex);

        if (keyword == null || keyword.trim().isEmpty()) {
            // 전체 문서 검색 + createdAt 내림차순 정렬
            searchBuilder
                .query(q -> q.matchAll(m -> m))
                .sort(s -> s
                    .field(f -> f
                        .field("createdAt")
                        .order(SortOrder.Desc)
                    )
                );
        } else {
            // 키워드 기반 검색: bool_prefix + n-gram
            searchBuilder.query(q -> q
                .bool(b -> b
                    .should(s1 -> s1
                        .multiMatch(mm -> mm
                            .query(keyword)
                            .type(TextQueryType.BoolPrefix)    // bool_prefix 타입 사용
                            .fields("title^3", "title._2gram^2", "title._3gram^1",
                                "tags^2", "tags._2gram^1", "tags._3gram^1",
                                "description")
                            .tieBreaker(0.3)
                        )
                    )
                    .minimumShouldMatch("1") // should 조건 중 최소 1개 만족
                )
            );
        }

        SearchResponse<JsonData> response = esClient.search(
            searchBuilder.build(),
            JsonData.class
        );

        return response.hits().hits().stream()
            .map(hit -> {
                Object sourceObj = hit.source().to(Map.class);
                return objectMapper.convertValue(sourceObj, VideoPostDto.class);
            })
            .toList();
    }
}
