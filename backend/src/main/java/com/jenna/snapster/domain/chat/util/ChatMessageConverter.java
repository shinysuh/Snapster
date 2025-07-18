package com.jenna.snapster.domain.chat.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ChatMessageConverter {

    private final ObjectMapper objectMapper;

    public ChatMessageDto fromJson(String json) {
        try {
            return objectMapper.readValue(json, ChatMessageDto.class);
        } catch (JsonProcessingException e) {
            throw new GlobalException(ErrorCode.CONVERT_FROM_JSON_ERROR);
        }
    }

    public String toJson(ChatMessageDto message) {
        try {
            return objectMapper.writeValueAsString(message);
        } catch (JsonProcessingException e) {
            throw new GlobalException(ErrorCode.CONVERT_TO_JSON_ERROR);
        }
    }
}
