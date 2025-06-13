package com.jenna.snapster.domain.chat.message.service;

import com.jenna.snapster.domain.chat.dto.ChatRequestDto;

public interface ChatMessageService {

    boolean processMessage(ChatRequestDto chatRequest, String senderId);
}
