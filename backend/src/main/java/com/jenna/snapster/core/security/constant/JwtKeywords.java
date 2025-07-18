package com.jenna.snapster.core.security.constant;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum JwtKeywords {

    AUTHORIZATION("Authorization"),
    BEARER("Bearer "),
    ;

    private final String keyword;
}
