import 'package:flutter/cupertino.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/stomp/services/stomp_service.dart';

class StompRepository {
  final StompService _stompService;

  StompRepository(this._stompService);

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
    _stompService.connect(accessToken);
  }

  void sendMessage(ChatMessageModel message) {
    _stompService.sendMessage(message);
  }

  void subscribeToChatroom(
    int chatroomId,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    _stompService.subscribeToChatroom(chatroomId, onMessage);
  }

  void subscribeToChatrooms(
    List<int> chatroomIds,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    _stompService.subscribeToChatrooms(chatroomIds, onMessage);
  }

  void unsubscribeFromChatroom(int chatroomId) {
    _stompService.unsubscribeFromChatroom(chatroomId);
  }

  void unsubscribeFromChatrooms(List<int> chatroomIds) {
    _stompService.unsubscribeFromChatrooms(chatroomIds);
  }

  void disconnect() {
    _stompService.disconnect();
  }

  void updateJwtToken(String newToken) {
    _stompService.updateJwtToken(newToken);
  }
}
