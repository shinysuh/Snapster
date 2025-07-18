package com.jenna.snapster.core.exception;

import lombok.Getter;

public class GlobalException extends RuntimeException {

    @Getter
    private ErrorCode errorCode;

    public GlobalException(String msg) {
        super(msg);
    }

    public GlobalException(ErrorCode errorCode) {
        super(errorCode.getMessage());
        this.errorCode = errorCode;
    }

    public GlobalException(ErrorCode errorCode, String msg) {
        super(String.format("%s | %s", errorCode.getMessage(), msg));
        this.errorCode = errorCode;
    }
}
