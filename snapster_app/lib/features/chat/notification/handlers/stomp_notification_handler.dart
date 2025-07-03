import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snapster_app/common/navigation/navigation.dart';
import 'package:snapster_app/features/authentication/renewal/providers/auth_status_provider.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/notification/widgets/notification_popup.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:snapster_app/features/chat/views/test_chat_detail_screen.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

// 실시간 수신 메시지 감지 => 알림 또는 UI 반영 처리 핸들러
class StompNotificationHandler {
  final WidgetRef ref;
  late final GlobalKey<NavigatorState> _navigatorKey;

  StompNotificationHandler(this.ref) {
    _navigatorKey = ref.read(navigatorKeyProvider);
    _init();
  }

  AppUser? _currentUser;

  void _init() {
    // 1. authStateProvider 감지해서 유저 세팅
    ref.listenManual(
      authStateProvider,
      (prev, next) {
        if (next.user != null && _currentUser == null) {
          _currentUser = next.user;
          debugPrint(
              '👤 currentUser set via listener: ${_currentUser?.displayName}');
        }
      },
    );

    ref.listenManual<AsyncValue<ChatMessageModel>>(
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
    if (message == null || _currentUser == null) return;
    debugPrint('✅ message: ${message.toJson()}');
    // ✅ 채팅방별 알림 뱃지, 로컬 알림, 알림 소리 등 원하는 처리를 여기에
    // _updateChatListBadge(message.chatroomId);

    final showNotification = _isSenderNotMe(_currentUser!, message.senderId) &&
        !_isChatroomAlreadyOnScreen(message.chatroomId);

    if (showNotification) {
      _showNotificationPopup(
        message,
        () => _goToChatroomDetail(message),
      );
    }
  }

  void _goToChatroomDetail(
    ChatMessageModel message,
  ) {
    goToRouteNamed(
      context: _navigatorKey.currentState!.context,
      routeName: TestChatDetailScreen.routeName,
      queryParams: {
        'chatroomId': message.chatroomId.toString(),
      },
      extra: ChatroomDetailParams(
        chatroomId: message.chatroomId,
        currentUser: _currentUser!,
        chatroom: null,
      ),
    );
  }

  void _showNotificationPopup(
    ChatMessageModel message,
    VoidCallback? onTap,
  ) {
    final overlay = _navigatorKey.currentState?.overlay;

    if (overlay == null) {
      debugPrint('❌ Overlay is null — cannot show notification popup');
      return;
    }

    NotificationPopup.show(
      overlay: overlay,
      message: message,
      onTap: onTap,
    );
  }

  bool _isSenderNotMe(AppUser currentUser, int senderId) {
    return currentUser.userId != senderId.toString();
  }

  bool _isChatroomAlreadyOnScreen(int chatroomId) {
    final navigator = _navigatorKey.currentState;
    if (navigator == null || !navigator.mounted) return true;

    final context = navigator.context;
    final currentLocation = GoRouter.of(context).location;

    final targetRoute = Uri(
      path: TestChatDetailScreen.routeURL,
      queryParameters: {
        'chatroomId': chatroomId.toString(),
      },
    ).toString();

    return currentLocation.endsWith(targetRoute);
  }

  void _updateChatListBadge(int chatroomId) {
    // 배지 갱신 로직, state 관리 등
  }

  void dispose() {
    // 필요한 경우 구독 해제 로직
  }
}
