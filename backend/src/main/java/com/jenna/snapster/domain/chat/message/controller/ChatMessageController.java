package com.jenna.snapster.domain.chat.message.controller;

import com.jenna.snapster.core.security.annotation.CurrentUser;
import com.jenna.snapster.core.security.util.CustomUserDetails;
import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.message.service.ChatMessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/chat/message")
public class ChatMessageController {

    private final ChatMessageService chatMessageService;

    @GetMapping("/{chatroomId}")
    public ResponseEntity<?> getAllMessagesByChatroom(@PathVariable Long chatroomId) {
        return ResponseEntity.ok(chatMessageService.getAllChatMessagesByChatroom(chatroomId));
    }

    @PostMapping("/recent/{chatroomId}")
    public ResponseEntity<?> getRecentMessageByChatroom(@PathVariable Long chatroomId,
                                                        @RequestBody Chatroom chatroom) {
        chatroom.setId(chatroomId);
        return ResponseEntity.ok(chatMessageService.getRecentMessageByChatroom(chatroom));
    }

    @PutMapping("/delete")
    public ResponseEntity<?> updateMessageToDeleted(@CurrentUser CustomUserDetails currentUser,
                                                    @RequestBody ChatRequestDto chatRequest) {
        return ResponseEntity.ok(chatMessageService.updateMessageToDeleted(currentUser.getUser().getId(), chatRequest));
    }
}
