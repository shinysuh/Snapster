import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/constants/authorization.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:uuid/uuid.dart';

class ChatService {
  static ChatService? _instance;

  factory ChatService() {
    return _instance ??= ChatService._internal();
  }

  ChatService._internal();

  static const _messageBaseUrl = '/app/chat/send.';

  late StompClient _stompClient;

  bool get isConnected => _stompClient.connected;

  late String _jwtToken;
  final _uuid = const Uuid();
  final _chatroomSubs = <int, void Function(Map<String, dynamic>)>{};

  int reconnectTrial = 0;

  void connect(String jwtToken) {
    _jwtToken = jwtToken;

    _stompClient = StompClient(
      config: StompConfig.SockJS(
        url: '${ApiInfo.baseUrl}/websocket',
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

  void sendMessage({
    required int chatroomId,
    required int senderId,
    required int receiverId,
    required String content,
    required String type, // TEXT, EMOJI, IMAGE
  }) {
    if (!_stompClient.connected) {
      debugPrint("Not connected");
      return;
    }

    final message = ChatMessageModel(
      id: 0,
      chatroomId: chatroomId,
      senderId: senderId,
      content: content,
      type: type,
      isDeleted: false,
      clientMessageId: _uuid.v4(),
      createdAt: 0,
    );

    _stompClient.send(
      destination: '$_messageBaseUrl$chatroomId',
      body: jsonEncode(message),
      headers: ApiInfo.getBasicHeaderWithToken(_jwtToken),
    );
  }

  void subscribeToChatroom(
    int chatroomId,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    _chatroomSubs[chatroomId] = onMessage;

    _stompClient.subscribe(
      destination: '/topic/chatroom.$chatroomId',
      callback: (frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          onMessage(data); // 수신된 메시지 전달
        }
      },
    );
  }

  void updateJwtToken(String newToken) {
    _jwtToken = newToken;
    if (_stompClient.connected) {
      _stompClient.deactivate();
    }
    connect(_jwtToken);
  }

  void disconnect() {
    _stompClient.deactivate();
  }
}
