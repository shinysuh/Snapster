import 'package:flutter/cupertino.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/message/services/chat_message_service.dart';

class ChatMessageRepository {
  final ChatMessageService _chatMessageService;

  ChatMessageRepository(this._chatMessageService);

  void initializeForUser(
    String accessToken,
    List<int> chatroomIds,
  ) {
    // 웹소켓 연결
    connectToWebSocket(accessToken);
    // 참여 중인 채팅방 일괄 구독
    subscribeToChatrooms(
      chatroomIds,
      (data) {
        // 전역으로 들어오는 메시지는 여기서 로깅하거나
        // 이후 ChatMessageViewModel로 전달해줄 수도 있음.
        debugPrint('[$chatroomIds] 메시지 수신: $data');
      },
    );
  }

  void connectToWebSocket(String accessToken) {
    _chatMessageService.connect(accessToken);
  }

  void sendMessage(ChatMessageModel message) {
    _chatMessageService.sendMessage(message);
  }

  void subscribeToChatroom(
    int chatroomId,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    _chatMessageService.subscribeToChatroom(chatroomId, onMessage);
  }

  void subscribeToChatrooms(
    List<int> chatroomIds,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    _chatMessageService.subscribeToChatrooms(chatroomIds, onMessage);
  }

  void unsubscribeFromChatroom(int chatroomId) {
    _chatMessageService.unsubscribeFromChatroom(chatroomId);
  }

  void unsubscribeFromChatrooms(List<int> chatroomIds) {
    _chatMessageService.unsubscribeFromChatrooms(chatroomIds);
  }

  void disconnect() {
    _chatMessageService.disconnect();
  }

  void updateJwtToken(String newToken) {
    _chatMessageService.updateJwtToken(newToken);
  }
}
