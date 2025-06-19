package com.jenna.snapster.domain.chat.message.service;

import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.dto.ChatRequestDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;

import java.util.List;

public interface ChatMessageService {

    boolean processMessage(ChatRequestDto chatRequest, String senderId);

    ChatMessage getRecentMessageByChatroom(Chatroom chatroom);

    List<ChatMessage> getAllChatMessagesByChatroom(Long chatroomId);

    ChatMessage saveChatMessageAndUpdateChatroom(ChatMessage message);
}
