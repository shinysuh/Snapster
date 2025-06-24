import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/message/services/chat_message_service.dart';

class ChatMessageRepository {
  final ChatMessageService _chatMessageService;

  ChatMessageRepository(this._chatMessageService);

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
