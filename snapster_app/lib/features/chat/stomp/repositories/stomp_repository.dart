import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/stomp/services/stomp_service.dart';

class StompRepository {
  final StompService _stompService;

  StompRepository(this._stompService);

  final _messageController = StreamController<ChatMessageModel>.broadcast(
    onListen: () => debugPrint('messageStream: listener attached'),
    onCancel: () => debugPrint('messageStream: listener detached'),
  );

  Stream<ChatMessageModel> get messageStream => _messageController.stream;
  bool _isDisposed = false;

  void _streamMessage(Map<String, dynamic> data) {
    try {
      final msg = ChatMessageModel.fromJson(data);
      _messageController.add(msg);
    } catch (e, st) {
      debugPrint('❌ [STOMP] 메시지 디코딩 실패: $e\n$st');
      _messageController.addError(e, st);
    }
  }

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    _messageController.close();
    debugPrint('🧹 StompRepository disposed and stream closed');
  }

  void disconnect() {
    _stompService.disconnect();
    dispose(); // 스트림 정리
  }

  Future<void> initializeForUser(
    String accessToken,
    List<int> chatroomIds,
  ) async {
    if (!_stompService.isConnected) {
      // 웹소켓 연결
      connectToWebSocket(accessToken);
      await waitUntilConnected();
    }
    // 참여 중인 채팅방 일괄 구독
    subscribeToChatrooms(
      chatroomIds,
      (data) {
        _streamMessage(data);
        debugPrint('[$chatroomIds] 메시지 수신: $data');
      },
    );
  }

  void connectToWebSocket(String accessToken) {
    if (!_stompService.isConnected) {
      _stompService.connect(accessToken);
    }
  }

  Future<void> waitUntilConnected({int retries = 30}) async {
    int retry = 0;
    while (!_stompService.isConnected && retry++ < retries) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (!_stompService.isConnected) {
      debugPrint('❌STOMP 연결 실패 after $retries attempts');
      throw Exception('STOMP 연결 실패');
    }
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

  void updateJwtToken(String newToken) {
    _stompService.updateJwtToken(newToken);
  }
}
