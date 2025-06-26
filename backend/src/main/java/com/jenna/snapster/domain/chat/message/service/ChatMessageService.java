package com.jenna.snapster.domain.chat.message.service;

import com.jenna.snapster.domain.chat.chatroom.entity.Chatroom;
import com.jenna.snapster.domain.chat.message.dto.ChatMessageDto;
import com.jenna.snapster.domain.chat.message.entity.ChatMessage;

import java.util.List;

public interface ChatMessageService {

    boolean processMessage(ChatMessageDto messageRequest, Long senderId);

    ChatMessage getRecentMessageByChatroom(Chatroom chatroom);

    List<ChatMessage> getAllChatMessagesByChatroom(Long chatroomId);

    ChatMessage saveChatMessageAndUpdateChatroom(ChatMessage message);

    ChatMessage updateMessageToDeleted(Long userId, ChatMessageDto messageRequest);
}
