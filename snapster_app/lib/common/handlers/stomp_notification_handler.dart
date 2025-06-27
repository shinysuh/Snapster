import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';

// 실시간 수신 메시지 감지 => 알림 또는 UI 반영 처리 핸들러
class StompNotificationHandler {
  final WidgetRef ref;

  // late final ProviderSubscription<AsyncValue<ChatMessageModel>> _subscription;

  StompNotificationHandler(this.ref) {
    _init();
  }

  void _init() {
    ref.listen<AsyncValue<ChatMessageModel>>(
      stompMessageStreamProvider,
      (previous, next) {
        if (next.hasValue) {
          final message = next.value;
          _handleIncomingMessage(message);
        }
      },
    );
  }

  void _handleIncomingMessage(ChatMessageModel? message) {
    if (message == null) return;
    debugPrint('✅✅✅ message: ${message.toJson()}');
    // ✅ 채팅방별 알림 뱃지, 로컬 알림, 알림 소리 등 원하는 처리를 여기에
    _showLocalNotification(message);
    _updateChatListBadge(message.chatroomId);
  }

  void _showLocalNotification(ChatMessageModel message) {}

  void _updateChatListBadge(int chatroomId) {
    // 배지 갱신 로직, state 관리 등
  }

  void dispose() {
    // 필요한 경우 구독 해제 로직
  }
}
