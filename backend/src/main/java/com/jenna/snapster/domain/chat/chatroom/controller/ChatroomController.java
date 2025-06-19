package com.jenna.snapster.domain.chat.chatroom.controller;

import com.jenna.snapster.core.security.annotation.CurrentUser;
import com.jenna.snapster.core.security.util.CustomUserDetails;
import com.jenna.snapster.domain.chat.chatroom.service.ChatroomService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/chat/chatroom")
public class ChatroomController {

    private final ChatroomService chatroomService;

    @GetMapping("")
    public ResponseEntity<?> getAllChatroomsByUserId(@CurrentUser CustomUserDetails currentUser) {
        return ResponseEntity.ok(chatroomService.getAllChatroomsByUserId(currentUser.getUser().getId()));
    }

    @GetMapping("/one/{chatroomId}}")
    public ResponseEntity<?> getOneChatroom(@CurrentUser CustomUserDetails currentUser,
                                            @PathVariable Long chatroomId) {
        return ResponseEntity.ok(chatroomService.getOneChatroomByIdAndUser(chatroomId, currentUser.getUser().getId()));
    }
}
