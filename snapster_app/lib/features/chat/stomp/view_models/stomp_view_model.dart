import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/message/repositories/chat_message_repository.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:snapster_app/features/chat/stomp/repositories/stomp_repository.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';
import 'package:uuid/uuid.dart';

class StompViewModel extends FamilyAsyncNotifier<List<ChatMessageModel>, int> {
  late final StreamSubscription<ChatMessageModel> _subscription;

  late final StompRepository _stompRepository;
  late final ChatMessageRepository _messageRepository;
  late final int _chatroomId;

  final _uuid = const Uuid();

  @override
  FutureOr<List<ChatMessageModel>> build(int arg) async {
    _stompRepository = ref.watch(stompRepositoryProvider);
    _messageRepository = ref.watch(chatMessageRepositoryProvider);
    _chatroomId = arg;

    await _ensureStompConnected();

    // 초기 메시지 리스트 (DB)
    final messages = await _getMessagesByChatroom();
    // 2) STOMP 실시간 메시지 구독 등록
    subscribeChatroom();

    _subscription = _stompRepository.messageStream
        .where((msg) => msg.chatroomId == _chatroomId)
        .listen((msg) {
      final prev = state.asData?.value ?? [];
      state = AsyncValue.data([msg, ...prev]);
    });

    ref.onDispose(() {
      leaveRoom();
    });

    return messages;
  }

  Future<void> _ensureStompConnected() async {
    try {
      await _stompRepository.waitUntilConnected();
    } catch (e) {
      debugPrint('❌ STOMP 연결 실패: $e');
    }
  }

  Future<List<ChatMessageModel>> _getMessagesByChatroom() async {
    return await runFutureWithExceptionLogs<List<ChatMessageModel>>(
      errorPrefix: '채팅방 전체 메시지 조회(초기화)',
      requestFunction: () async =>
          _messageRepository.getAllMessagesByChatroom(_chatroomId),
      fallback: [],
    );
  }

  void sendMessageToRoom({
    required BuildContext context,
    required int senderId,
    int? receiverId,
    required String content,
    required String type, // MessageType: text, emoji, image
  }) {
    final message = ChatMessageModel(
      id: 0,
      chatroomId: _chatroomId,
      senderId: senderId,
      receiverId: receiverId,
      content: content,
      type: type,
      isDeleted: false,
      clientMessageId: _uuid.v4(),
    );

    _stompRepository.sendMessage(message);
  }

  void subscribeChatroom() {
    _stompRepository.subscribeToChatroom(
      _chatroomId,
      (data) async {
        state = await AsyncValue.guard(() async {
          final msg = ChatMessageModel.fromJson(data);
          final prev = state.asData?.value ?? [];
          return [msg, ...prev];
        });
      },
    );
  }

  void leaveRoom() {
    _subscription.cancel();
    _stompRepository.unsubscribeFromChatroom(_chatroomId);
  }
}

final stompProvider =
    AsyncNotifierProvider.family<StompViewModel, List<ChatMessageModel>, int>(
  StompViewModel.new,
);
