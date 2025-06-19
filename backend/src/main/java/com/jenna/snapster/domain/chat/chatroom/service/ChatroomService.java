package com.jenna.snapster.domain.chat.chatroom.service;

import com.jenna.snapster.domain.chat.chatroom.dto.ChatroomResponseDto;
import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;

import java.util.List;

public interface ChatroomService {

    Chatroom getChatroomById(Long chatroomId);

    ChatroomResponseDto getOneChatroomByIdAndUser(Long chatroomId, Long userId);

    List<ChatroomResponseDto> getAllChatroomsByUserId(Long userId);

    Chatroom openNewChatroom(ChatRequestDto chatRequest);

    Chatroom getChatroomByIdAndCreatedIfNotExists(ChatRequestDto chatRequest);

    Chatroom updateChatroomLastMessageId(ChatMessage message);
}
