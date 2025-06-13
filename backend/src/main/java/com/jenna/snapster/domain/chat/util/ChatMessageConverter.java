package com.jenna.snapster.domain.chat.util;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.exception.GlobalException;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ChatMessageConverter {

    private final ObjectMapper objectMapper;

    public ChatMessage fromJson(String json) {
        try {
            return objectMapper.readValue(json, ChatMessage.class);
        } catch (JsonProcessingException e) {
            throw new GlobalException(ErrorCode.CONVERT_FROM_JSON_ERROR);
        }
    }

    public String toJson(ChatMessage message) {
        try {
            return objectMapper.writeValueAsString(message);
        } catch (JsonProcessingException e) {
            throw new GlobalException(ErrorCode.CONVERT_TO_JSON_ERROR);
        }
    }
}
