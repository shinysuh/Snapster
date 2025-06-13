package com.jenna.snapster.domain.chat.chatroom.service;

import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.dto.ChatRequestDto;

public interface ChatroomService {

    Chatroom getChatroomById(Long chatroomId);

    Chatroom openNewChatroom(ChatRequestDto chatRequest);

    Chatroom getChatroomByIdAndCreatedIfNotExists(ChatRequestDto chatRequest);
}
