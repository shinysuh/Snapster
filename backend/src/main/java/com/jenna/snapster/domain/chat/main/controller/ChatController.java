package com.jenna.snapster.domain.chat.main.controller;

import com.jenna.snapster.core.exception.ErrorCode;
import com.jenna.snapster.core.security.util.CustomUserDetails;
import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import com.jenna.snapster.domain.chat.message.service.ChatMessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import java.security.Principal;

@Controller
@RequiredArgsConstructor
@MessageMapping("/chat")
public class ChatController {

    private final ChatMessageService chatMessageService;

    @MessageMapping("/send/{chatroomId}")
    public ResponseEntity<?> onMessage(@DestinationVariable Long chatroomId,
                                       @Payload ChatMessageDto messageRequest,
                                       Principal principal) {
        messageRequest.setChatroomId(chatroomId);
        CustomUserDetails currentUser = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        Long userId = currentUser.getUser().getId();
        boolean isSuccess = chatMessageService.processMessage(messageRequest, userId);
        return ResponseEntity.ok(isSuccess ? "Message Successfully Sent" : ErrorCode.MESSAGE_NOT_DELIVERED.getMessage());
    }
}
