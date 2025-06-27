import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snapster_app/common/navigation/navigation.dart';
import 'package:snapster_app/features/authentication/renewal/providers/auth_status_provider.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/chatroom/view_models/chatroom_view_model.dart';
import 'package:snapster_app/features/chat/views/test_chat_detail_screen.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class FCMNotificationHandler {
  final WidgetRef ref;

  FCMNotificationHandler(this.ref);

  late final GlobalKey<NavigatorState> _navigatorKey =
      ref.read(navigatorKeyProvider);

  void initFCMListeners() {
    // 앱 종료 상태에서 푸시 알림 눌렀을 때
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleMessage(message);
      }
    });

    // 앱 백그라운드 상태에서 푸시 눌렀을 때
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessage(message);
    });

    // fcm 수신 테스트 - 온라인
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
          '[FCM 테스트] onMessage 받음: ${message.data}, notification=${message.notification}');
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage message) async {
    final navigator = _navigatorKey.currentState;
    if (navigator == null || !navigator.mounted) return;

    final data = message.data;
    final chatroomId = int.tryParse(data['chatroomId'] ?? '');
    if (chatroomId == null) return;

    try {
      final chatroom = await _getChatroom(chatroomId);
      if (chatroom.isEmpty()) return;

      final currentUser = _getCurrentUser();
      if (currentUser == null) return;

      navigateToChatroom(navigator, chatroom, currentUser);
    } catch (e) {
      debugPrint('❌ 푸시 클릭 이동 실패: $e');
    }
  }

  void navigateToChatroom(
    NavigatorState navigator,
    ChatroomModel chatroom,
    AppUser currentUser,
  ) {
    final context = navigator.context;
    final currentLocation = GoRouter.of(context).location;

    final targetRoute = Uri(
      path: TestChatDetailScreen.routeURL,
      queryParameters: {
        'chatroomId': chatroom.id.toString(),
      },
    ).toString();

    debugPrint(
        '❌ 현재: $currentLocation, 타겟: $targetRoute, 일치: ${currentLocation.endsWith(targetRoute)}');
    if (currentLocation.endsWith(targetRoute)) {
      goToRouteNamed(
        context: context,
        routeName: TestChatDetailScreen.routeName,
        queryParams: {
          'chatroomId': chatroom.id.toString(),
        },
        extra: ChatroomDetailParams(
          chatroomId: chatroom.id,
          chatroom: chatroom,
          currentUser: currentUser,
        ),
      );
    } else {
      debugPrint('❌현재 채팅방');
    }
  }

  Future<ChatroomModel> _getChatroom(int chatroomId) async {
    return await ref.read(httpChatroomProvider.notifier).getOneChatroom(
          context: _navigatorKey.currentState!.context,
          chatroomId: chatroomId,
        );
  }

  AppUser? _getCurrentUser() {
    final authState = ref.watch(authStateProvider);
    return authState.user;
  }
}
