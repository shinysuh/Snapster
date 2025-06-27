package com.jenna.snapster.core.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

import static org.springframework.http.HttpStatus.*;


@Getter
@AllArgsConstructor
public enum ErrorCode {

    ERROR_UNKNOWN("UNKNOWN001", "알 수 없는 에러가 발생했습니다. \n관리자에게 문의해주세요", INTERNAL_SERVER_ERROR),

    // security
    NOT_LOGGED_IN("SECURITY001", "로그인이 필요한 작업입니다. 먼저 로그인 해주세요.", UNAUTHORIZED),
    NO_AUTHORIZED_USER("SECURITY002", "현재 인증된 유저가 없습니다.", UNAUTHORIZED),
//    SESSION_EXPIRED("SECURITY003", "세션이 만료 되었습니다. 다시 로그인 해주세요.", UNAUTHORIZED),

    // oauth2
    INVALID_PROVIDER("PRV001", "허용되지 않는 provider 입니다.", UNAUTHORIZED),
    REDIRECTION_EXCEPTION("PRV002", "앱으로 돌아가는 도중 에러가 발생했습니다.", INTERNAL_SERVER_ERROR),

    // token
    TOKEN_EXPIRED("JWT001", "토큰이 만료되었습니다.", UNAUTHORIZED),
    INVALID_TOKEN("JWT002", "토큰이 비어있거나 잘못되었습니다.", UNAUTHORIZED),
    INVALID_REFRESH_TOKEN("JWT004", "유효하지 않은 리프레시 토큰입니다.", UNAUTHORIZED),
    TOKEN_MALFORMED("JWT004", "잘못된 JWT 토큰입니다.", UNAUTHORIZED),
    INVALID_SIGNATURE("JWT005", "서명이 유효하지 않은 토큰입니다.", UNAUTHORIZED),
    INVALID_ISSUER("JWT005", "허용되지 않는 issuer입니다.", UNAUTHORIZED),

    // users
    USER_NOT_EXISTS("USER001", "사용자 정보가 존재하지 않습니다.", BAD_REQUEST),
    EMPTY_USER_DATA("USER002", "사용자 데이터가 비어 있습니다.", BAD_REQUEST),
    USER_EMAIL_NOT_EXISTS("USER003", "사용자 이메일이 존재하지 않습니다.", BAD_REQUEST),
    USER_PW_NOT_MATCHED("USER004", "비밀번호가 일치하지 않습니다.", BAD_REQUEST),
    USERNAME_ALREADY_EXISTS("USER005", "이미 사용 중인 이름입니다.", BAD_REQUEST),
    USER_EMAIL_ALREADY_EXISTS("USER006", "이미 사용 중인 이메일 주소입니다.", BAD_REQUEST),
    USER_REGISTER_ERROR("USER007", "회원 가입 도중 오류가 발생했습니다. \n관리자에게 문의해주세요", INTERNAL_SERVER_ERROR),
    USER_UPDATE_ERROR("USER008", "사용자 정보를 수정하는 도중 오류가 발생했습니다. \n관리자에게 문의해주세요", INTERNAL_SERVER_ERROR),
    USER_DELETE_ERROR("USER009", "사용자 정보를 삭제하는 도중 오류가 발생했습니다. \n관리자에게 문의해주세요", INTERNAL_SERVER_ERROR),
    INVALID_USER_ACCESS("USER010", "사용자 정보가 일치하지 않습니다.", UNAUTHORIZED),

    // profile
    USER_NAME_REQUIRED("PRF001", "사용자명을 입력해주세요.", BAD_REQUEST),
    DISPLAY_NAME_REQUIRED("PRF002", "사용자 닉네임을 입력해주세요.", BAD_REQUEST),

    // file
    NO_SUCH_FILE("FILE001", "존재하지 않는 파일입니다.", BAD_REQUEST),
    FILE_DELETE_ACTION_UNAUTHORIZED("FILE002", "해당 파일을 삭제할 권한이 없습니다.", UNAUTHORIZED),
    FAILED_TO_CREAT_THUMBNAIL("FILE003", "썸네일 생성 도중 오류가 발생했습니다", INTERNAL_SERVER_ERROR),
    FAILED_TO_UPLOAD_THUMBNAIL("FILE004", "썸네일 업로드 도중 오류가 발생했습니다", INTERNAL_SERVER_ERROR),

    // chatroom
    CHATROOM_NOT_EXISTS("CHAT001", "채팅방 정보가 존재하지 않습니다.", BAD_REQUEST),
    UNAUTHORIZED_INVITATION_REQUEST("CHAT002", "채팅방에 대한 권한이 없습니다.", UNAUTHORIZED),
    RECEIVER_NOT_EXISTS("CHAT003", "채팅 상대의 정보가 존재하지 않습니다.", BAD_REQUEST),

    // chat message
    MESSAGE_NOT_DELIVERED("MSG001", "메시지 전송 실패", INTERNAL_SERVER_ERROR),
    INVALID_MESSAGE_SENDER("MSG002", "메시지 발신인 정보가 잘못되었습니다. 로그인 정보를 확인해주세요.", BAD_REQUEST),
    MESSAGE_NOT_FOUND("MSG003", "존재하지 않는 메시지입니다.", BAD_REQUEST),

    // firebase
    FIREBASE_INITIALIZATION_FAILED("FRB001", "Firebase 초기화 실패", INTERNAL_SERVER_ERROR),

    // json
    CONVERT_TO_JSON_ERROR("JSON001", "객체 직렬화 실패", INTERNAL_SERVER_ERROR),
    CONVERT_FROM_JSON_ERROR("JSON002", "객체 역직렬화 실패", INTERNAL_SERVER_ERROR),
    ;

    private final String code;
    private final String message;
    private final HttpStatus status;
}
