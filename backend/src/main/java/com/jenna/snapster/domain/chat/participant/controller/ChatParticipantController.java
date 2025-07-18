package com.jenna.snapster.domain.chat.participant.controller;

import com.jenna.snapster.core.security.annotation.CurrentUser;
import com.jenna.snapster.core.security.util.CustomUserDetails;
import com.jenna.snapster.domain.chat.participant.dto.ChatroomParticipantDto;
import com.jenna.snapster.domain.chat.participant.dto.MultipleParticipantsRequestDto;
import com.jenna.snapster.domain.chat.participant.entity.ChatroomParticipantId;
import com.jenna.snapster.domain.chat.participant.service.ChatroomParticipantService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/chat/participant")
public class ChatParticipantController {

    private final ChatroomParticipantService participantService;

    @GetMapping("/{chatroomId}")
    public ResponseEntity<?> getAllByChatroom(@PathVariable Long chatroomId) {
        return ResponseEntity.ok(participantService.getAllWithReadStatusByChatroom(chatroomId));
    }

    @PostMapping("/one")
    public ResponseEntity<?> inviteUserToChatroom(@CurrentUser CustomUserDetails currentUser,
                                            @RequestBody ChatroomParticipantId id) {
        return ResponseEntity.ok(participantService.inviteUserToChatroom(id, currentUser.getUser().getId()));
    }

    @PostMapping("/multiple/{chatroomId}")
    public ResponseEntity<?> inviteMultipleUsersToChatroom(@CurrentUser CustomUserDetails currentUser,
                                             @RequestBody MultipleParticipantsRequestDto addRequestDto) {
        return ResponseEntity.ok(participantService.inviteMultipleUsersToChatroom(addRequestDto, currentUser.getUser().getId()));
    }

    @PutMapping("/read")
    public ResponseEntity<?> updateLastReadMessage(@CurrentUser CustomUserDetails currentUser,
                                                   @RequestBody ChatroomParticipantDto participant) {
        participant.getId().setUserId(currentUser.getUser().getId());
        participantService.updateLastReadMessage(participant);
        return ResponseEntity.ok().build();
    }
}
