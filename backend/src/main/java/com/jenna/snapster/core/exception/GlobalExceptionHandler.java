package com.jenna.snapster.core.exception;


import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.JwtValidationException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import static org.springframework.http.HttpStatus.*;

@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(value = Exception.class)
    public ResponseEntity<?> handleAllException(Exception e) {
        logException(e);
        HttpStatus status = determineStatus(e);
        ErrorDTO error = buildErrorDTO(e, status);

        return buildErrorResponse(error, status);
    }

    @ExceptionHandler(value = JwtValidationException.class)
    public ResponseEntity<ErrorDTO> handleJwtException(JwtValidationException e) {
        log.warn("JWT 예외 발생: {}", e.getMessage());
        return buildErrorResponse(e, BAD_REQUEST);
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<Void> handleNoResource(NoResourceFoundException e) {
        return ResponseEntity.notFound().build();
    }

    @ExceptionHandler(value = MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorDTO> handleInvalidMethodArgumentException(MethodArgumentNotValidException e) {
        log.warn("Validation 예외 발생");

        String message = e.getBindingResult().getFieldErrors().stream()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .findFirst()
            .orElse("요청 값이 유효하지 않습니다.");

        ErrorDTO error = this.buildErrorDTO(
            e.getClass().getSimpleName(),
            "VALIDATION_ERROR",
            message,
            BAD_REQUEST
        );

        return buildErrorResponse(error, BAD_REQUEST);
    }

    private ResponseEntity<ErrorDTO> buildErrorResponse(Exception e, HttpStatus status) {
        return new ResponseEntity<>(buildErrorDTO(e, status), status);
    }

    private ResponseEntity<ErrorDTO> buildErrorResponse(ErrorDTO error, HttpStatus status) {
        return new ResponseEntity<>(error, status);
    }

    // 에러 로깅
    private void logException(Exception e) {
        if (e instanceof GlobalException) {
            log.warn("Handled GlobalException: {}", e.getMessage());
        } else {
            log.error("Unhandled exception caught", e);
        }
    }

    // ErrorDTO 생성
    private ErrorDTO buildErrorDTO(Exception e, HttpStatus status) {
//        HttpStatus status = determineStatus(e);
        String code = "NO_CATCH_ERROR";
        String message = e.getMessage();
        String exClassName = e.getClass().getSimpleName();

        if (e instanceof GlobalException ge) {
            code = ge.getErrorCode().getCode();
            message = ge.getErrorCode().getMessage();
        }

        return this.buildErrorDTO(exClassName, code, message, status);
    }

    private ErrorDTO buildErrorDTO(
        String exClassName,
        String code,
        String message,
        HttpStatus status
    ) {
        return ErrorDTO.builder()
            .exception(exClassName)
            .error(status.getReasonPhrase())
            .code(code)
            .message(message)
            .status(status.value())
            .build();
    }

    // status 설정
    private HttpStatus determineStatus(Exception e) {
        if (e instanceof GlobalException ge) {
            return ge.getErrorCode().getStatus();
        } else if (e instanceof HttpRequestMethodNotSupportedException) {
            return METHOD_NOT_ALLOWED;
        }
        return INTERNAL_SERVER_ERROR;
    }
}

