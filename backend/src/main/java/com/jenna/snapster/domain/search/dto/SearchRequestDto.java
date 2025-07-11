package com.jenna.snapster.domain.search.dto;

import lombok.Data;

@Data
public class SearchRequestDto {

    private String keyword;

    private int page;

}
