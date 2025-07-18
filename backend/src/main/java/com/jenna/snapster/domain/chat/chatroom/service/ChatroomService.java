package com.jenna.snapster.domain.chat.chatroom.service;

import com.jenna.snapster.domain.chat.chatroom.dto.ChatroomResponseDto;
import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;

import java.util.List;

public interface ChatroomService {

    Chatroom getChatroomById(Long chatroomId);

    ChatroomResponseDto getOneChatroomByIdAndUser(Long chatroomId, Long userId);

    ChatroomResponseDto getIfOneOnOneChatroomExists(Long senderId, Long receiverId);

    List<ChatroomResponseDto> getAllChatroomsByUserId(Long userId);

    Chatroom openNewChatroom(ChatMessageDto messageRequest);

    Chatroom getChatroomByIdAndCreatedIfNotExists(ChatMessageDto messageRequest);

    Chatroom updateChatroomLastMessageId(ChatMessage message);

    void leaveChatroom(Long chatroomId, Long userId);
}
