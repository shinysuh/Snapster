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

  StompClient? _stompClient;

  bool get isConnected => _stompClient?.connected == true;

  int _reconnectTrial = 0;
  bool _isConnecting = false;

  late String _jwtToken;
  final _chatroomSubs = <int, void Function(Map<String, dynamic>)>{};
  final _subscriptions = <int, void Function()>{}; // 구독 해제용 (클라이언트)

  void connect(String jwtToken) {
    _jwtToken = jwtToken;

    if (isConnected || _isConnecting) {
      debugPrint("⚠️STOMP 이미 연결 중 또는 연결됨");
      return;
    }

    debugPrint("STOMP 연결 시작...");
    _isConnecting = true;

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
          _isConnecting = false;
          _tryReconnect();
        },
        onWebSocketDone: () {
          debugPrint('WebSocket closed.');
          _isConnecting = false;
          _tryReconnect();
        },
        onDisconnect: (frame) {
          debugPrint('STOMP 연결 해제됨');
          _isConnecting = false;
        },
        onStompError: (frame) {
          debugPrint('STOMP error: ${frame.body}');
          _isConnecting = false;
        },
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

    _stompClient!.activate();
  }

  void _onConnect(StompFrame frame) {
    debugPrint('STOMP 연결 성공');
    _isConnecting = false;
    _reconnectTrial = 0;

    // 재연결 시 기존 구독 복구
    for (var entry in _chatroomSubs.entries) {
      subscribeToChatroom(entry.key, entry.value);
    }
  }

  void _tryReconnect() {
    if (_reconnectTrial > 4) {
      debugPrint("====== STOMP 재연결 시도 중단 (최대 횟수 초과) ======");
      return;
    }

    if (_stompClient?.connected != true) {
      _reconnectTrial++;
      debugPrint("====== STOMP 재연결 시도 $_reconnectTrial ======");
      Future.delayed(const Duration(seconds: 3), () {
        if (_stompClient == null) {
          debugPrint("⚠️재연결 시도 불가: StompClient가 null임");
          return;
        }

        debugPrint('STOMP 재활성화 시도...');
        _stompClient!.activate();
      });
    }
  }

  void sendMessage(ChatMessageModel message) {
    if (!isConnected) {
      debugPrint("❌STOMP 연결되지 않음. 메시지 전송 실패");
      return;
    }

    final destination = '$_messageBaseUrl/${message.chatroomId}';
    _stompClient!.send(
      destination: destination,
      body: jsonEncode(message),
      headers: ApiInfo.getBasicHeaderWithToken(_jwtToken),
    );
  }

  void subscribeToChatroom(
    int chatroomId,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    // 중복 구독 방지 로직
    if (_subscriptions.containsKey(chatroomId)) {
      debugPrint('이미 구독된 채팅방: $chatroomId');
      return;
    }

    if (!isConnected) {
      debugPrint("❌STOMP 미연결 상태. 구독 불가");
      return;
    }

    _chatroomSubs[chatroomId] = onMessage;

    final subscription = _stompClient!.subscribe(
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
    debugPrint('채팅방 $chatroomId 구독 해제됨');
  }

  void unsubscribeFromChatrooms(List<int> chatroomIds) {
    for (var id in chatroomIds) {
      unsubscribeFromChatroom(id);
    }
  }

  void disconnect() {
    debugPrint("STOMP 연결 해제 시작");

    for (var unsub in _subscriptions.values) {
      unsub(); // 연결 해제 전 전체 unsubscribe
    }
    _subscriptions.clear();
    _chatroomSubs.clear();

    _stompClient?.deactivate();
    _stompClient = null;
    _isConnecting = false;
    // _stompClient.deactivate();
  }

  void updateJwtToken(String newToken) {
    _jwtToken = newToken;
    if (isConnected) {
      _stompClient?.deactivate();
    }
    connect(_jwtToken);
  }
}
