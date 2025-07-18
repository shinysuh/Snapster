package com.jenna.snapster.core.exception;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ErrorDTO {
    private String exception;

    private String error;

    private String code;

    private String message;

    private int status;
}
