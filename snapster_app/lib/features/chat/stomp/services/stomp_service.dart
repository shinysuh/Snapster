import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/renewal/constants/authorization.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class StompService {
  static StompService? _instance;

  factory StompService() {
    return _instance ??= StompService._internal();
  }

  StompService._internal();

  static const _messageBaseUrl = ApiInfo.stompBaseUrl;

  late StompClient _stompClient;

  bool get isConnected => _stompClient.connected;

  late String _jwtToken;
  final _chatroomSubs = <int, void Function(Map<String, dynamic>)>{};
  final _subscriptions = <int, void Function()>{}; // 구독 해제용 (클라이언트)

  int reconnectTrial = 0;

  void connect(String jwtToken) {
    _jwtToken = jwtToken;

    _stompClient = StompClient(
      config: StompConfig.SockJS(
        url: ApiInfo.webSocketUrl,
        // SockJS endpoint
        onConnect: _onConnect,
        beforeConnect: () async {
          debugPrint('Connecting to STOMP...');
          await Future.delayed(const Duration(milliseconds: 500));
        },
        onWebSocketError: (error) {
          debugPrint('WebSocket error: $error');
          _tryReconnect();
        },
        onWebSocketDone: () {
          debugPrint('WebSocket closed.');
          _tryReconnect();
        },
        onDisconnect: (frame) => debugPrint('Disconnected from STOMP'),
        onStompError: (frame) => debugPrint('STOMP error: ${frame.body}'),
        onDebugMessage: (msg) => debugPrint('Debug: $msg'),
        stompConnectHeaders: {
          Authorizations.headerKey:
              '${Authorizations.headerValuePrefix} $_jwtToken',
        },
        webSocketConnectHeaders: {
          Authorizations.headerKey:
              '${Authorizations.headerValuePrefix} $_jwtToken',
        },
        heartbeatIncoming: const Duration(seconds: 5),
        heartbeatOutgoing: const Duration(seconds: 5),
        connectionTimeout: const Duration(seconds: 10),
        reconnectDelay: const Duration(seconds: 5),
      ),
    );

    _stompClient.activate();
  }

  void _onConnect(StompFrame frame) {
    debugPrint('Connected to STOMP');
    // 재연결 시 기존 구독 복구
    for (var entry in _chatroomSubs.entries) {
      subscribeToChatroom(entry.key, entry.value);
    }
  }

  void _tryReconnect() {
    if (reconnectTrial > 4) {
      debugPrint("====== STOMP Reconnect Trial Terminated ======");
      return;
    }

    if (!_stompClient.connected) {
      reconnectTrial++;
      debugPrint("====== STOMP Reconnect Trial $reconnectTrial ======");
      Future.delayed(const Duration(seconds: 3), () {
        debugPrint('Reconnecting to STOMP...');
        _stompClient.activate();
      });
    }
  }

  void sendMessage(ChatMessageModel message) {
    if (!_stompClient.connected) {
      debugPrint("Not connected");
      return;
    }

    _stompClient.send(
      destination: '$_messageBaseUrl${message.chatroomId}',
      body: jsonEncode(message),
      headers: ApiInfo.getBasicHeaderWithToken(_jwtToken),
    );
  }

  void subscribeToChatroom(
    int chatroomId,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    // 중복 구독 방지 로직
    if (_subscriptions.containsKey(chatroomId)) return;

    _chatroomSubs[chatroomId] = onMessage;

    final subscription = _stompClient.subscribe(
      destination: '/topic/chatroom.$chatroomId',
      callback: (frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          onMessage(data); // 수신된 메시지 전달
        }
      },
    );

    _subscriptions[chatroomId] = subscription;
  }

  void subscribeToChatrooms(
    List<int> chatroomIds,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    for (var id in chatroomIds) {
      subscribeToChatroom(id, onMessage);
    }
  }

  void unsubscribeFromChatroom(int chatroomId) {
    _subscriptions.remove(chatroomId)?.call();
    _chatroomSubs.remove(chatroomId);
  }

  void unsubscribeFromChatrooms(List<int> chatroomIds) {
    for (var id in chatroomIds) {
      unsubscribeFromChatroom(id);
    }
  }

  void disconnect() {
    for (var unsub in _subscriptions.values) {
      unsub(); // 연결 해제 전 전체 unsubscribe
    }
    _subscriptions.clear();
    _chatroomSubs.clear();

    _stompClient.deactivate();
  }

  void updateJwtToken(String newToken) {
    _jwtToken = newToken;
    if (_stompClient.connected) {
      _stompClient.deactivate();
    }
    connect(_jwtToken);
  }
}
