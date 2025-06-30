import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snapster_app/common/navigation/navigation.dart';
import 'package:snapster_app/features/authentication/renewal/providers/auth_status_provider.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/chatroom/view_models/chatroom_view_model.dart';
import 'package:snapster_app/features/chat/message/models/chat_message_model.dart';
import 'package:snapster_app/features/chat/notification/providers/fcm_token_providers.dart';
import 'package:snapster_app/features/chat/notification/widgets/notification_popup.dart';
import 'package:snapster_app/features/chat/stomp/view_models/stomp_view_model.dart';
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
        _handleMessageOffline(message);
      }
    });

    // 앱 백그라운드 상태에서 푸시 눌렀을 때
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageOffline(message);
    });

    // fcm 수신 테스트 - 온라인
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
          '[FCM 테스트] onMessage 받음: ${message.data}, notification=${message.notification}');
      _handleMessageOnline(message);
    });
  }

  Future<void> checkAndNavigateToChatroom() async {
    final fcmUtil = ref.read(fcmTokenUtilProvider);
    final chatroomId = await fcmUtil.loadFCMChatroomId();
    if (chatroomId == null || chatroomId == 0) return;

    final currentUser = _getCurrentUser();
    if (currentUser == null) return;

    final navigator = _navigatorKey.currentState;
    if (navigator == null || !navigator.mounted) return;

    navigateToChatroom(navigator, chatroomId, currentUser);
    await fcmUtil.clearFCMChatroomId();
  }

  ChatMessageModel _convertToChatMessage(RemoteMessage message) {
    final data = jsonDecode(message.data['message']);
    return ChatMessageModel.fromJson(data);
  }

  void _handleMessageOffline(RemoteMessage message) async {
    try {
      final receivedMsg = _convertToChatMessage(message);
      final chatroomId = receivedMsg.chatroomId;

      // 채팅방id -> SharedPreferences에 저장
      await ref.read(fcmTokenUtilProvider).storeFCMChatroomId(chatroomId);
    } catch (e) {
      debugPrint('❌ 푸시 클릭 처리 실패: $e');
    }
  }

  void _handleMessageOnline(RemoteMessage message) async {
    try {
      final navigator = _navigatorKey.currentState;
      if (navigator == null || !navigator.mounted) return;

      final receivedMsg = _convertToChatMessage(message);
      final chatroomId = receivedMsg.chatroomId;
      if (chatroomId == 0) return;

      final chatroom = await _getChatroom(chatroomId);
      if (chatroom.isEmpty()) return;

      final currentUser = _getCurrentUser();
      if (currentUser == null) return;

      // 1. 채팅방 목록 새로고침
      await ref.read(httpChatroomProvider.notifier).refresh();
      // 2. 새로 초대된 채팅방 구독 처리
      ref.read(stompProvider(chatroomId).notifier).subscribeChatroom();
      // 3. 팝업 알림
      if (message.notification != null && navigator.overlay != null) {
        NotificationPopup.show(
          overlay: navigator.overlay!,
          message: receivedMsg.copyWith(
            senderDisplayName: 'FCM ][ ${receivedMsg.senderDisplayName}',
          ),
          onTap: () => navigateToChatroom(navigator, chatroomId, currentUser),
          popupColor: const Color(0xFFFDBBA8),
        );
      }
    } catch (e) {
      debugPrint('❌ 푸시 클릭 이동 실패: $e');
    }
  }

  void navigateToChatroom(
    NavigatorState navigator,
    int chatroomId,
    AppUser currentUser,
  ) {
    final context = navigator.context;
    final currentLocation = GoRouter.of(context).location;

    final targetRoute = Uri(
      path: TestChatDetailScreen.routeURL,
      queryParameters: {
        'chatroomId': chatroomId.toString(),
      },
    ).toString();

    if (!currentLocation.endsWith(targetRoute)) {
      goToRouteNamed(
        context: context,
        routeName: TestChatDetailScreen.routeName,
        queryParams: {
          'chatroomId': chatroomId.toString(),
        },
        extra: ChatroomDetailParams(
          chatroomId: chatroomId,
          currentUser: currentUser,
          chatroom: null,
        ),
      );
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
