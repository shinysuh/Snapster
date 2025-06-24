import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/renewal/providers/http_auth_provider.dart';
import 'package:snapster_app/features/authentication/renewal/providers/token_storage_provider.dart';
import 'package:snapster_app/features/authentication/renewal/repositories/http_auth_repository.dart';
import 'package:snapster_app/features/authentication/renewal/services/token_storage_service.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/chatroom/repositories/chatroom_repository.dart';
import 'package:snapster_app/features/chat/message/repositories/chat_message_repository.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';

class AuthViewModel extends AsyncNotifier<AppUser?> {
  late final AuthRepository _authRepository;
  late final TokenStorageService _tokenStorageService;
  late final ChatroomRepository _chatroomRepository;
  late final ChatMessageRepository _messageRepository;

  @override
  FutureOr<AppUser?> build() async {
    _authRepository = ref.read(authRepositoryProvider);
    _tokenStorageService = ref.read(tokenStorageServiceProvider);
    _chatroomRepository = ref.read(chatroomRepositoryProvider);
    _messageRepository = ref.read(chatMessageRepositoryProvider);

    final accessToken = await _tokenStorageService.readToken();
    return await _init(accessToken);
  }

  Future<AppUser?> _init(String? token) async {
    // 1) 토큰 복구 시도
    final restored = await _authRepository.restoreFromToken();
    final user = restored ? _authRepository.currentUser : null;

    if (user != null && token != null) {
      // 2) WebSocket 연결 & 참여 중인 채팅방 일괄 구독
      await _connectToWebSocket(token);
    }
    return user;
  }

  Future<void> _connectToWebSocket(String token) async {
    _messageRepository.connectToWebSocket(token);
    await _subscribeAllParticipatingChatrooms();
  }

  Future<void> _subscribeAllParticipatingChatrooms() async {
    // 참여 중인 채팅방 목록 (DB)
    List<ChatroomModel> chatrooms =
        await runFutureWithExceptionLogs<List<ChatroomModel>>(
      errorPrefix: '채팅방 목록 조회',
      requestFunction: () async => _chatroomRepository.getAllChatroomsByUser(),
      fallback: [],
    );

    // 참여 중인 채팅방 일괄 구독
    final chatroomIds = chatrooms.map((room) => room.id).toList();
    _messageRepository.subscribeToChatrooms(
      chatroomIds,
      (data) {
        // 전역으로 들어오는 메시지는 여기서 로깅하거나
        // 이후 ChatMessageViewModel로 전달해줄 수도 있음.
        debugPrint('[$chatroomIds] 메시지 수신: $data');
      },
    );
  }

  // 딥링크 토큰 로그인
  Future<bool> loginWithDeepLink(Uri uri, WidgetRef ref) async {
    state = const AsyncValue.loading();

    final success =
        await _authRepository.storeTokenFromUriAndRestoreAuth(uri, ref);
    if (success) {
      state = AsyncValue.data(_authRepository.currentUser);
    } else {
      state = AsyncValue.error('로그인 실패', StackTrace.current);
    }
    return success;
  }

  // oauth 로그인
  Future<bool> socialLoginWithProvider({
    required BuildContext context,
    required WidgetRef ref,
    required String provider,
  }) async {
    state = const AsyncValue.loading();

    await _authRepository.socialLoginWithProvider(
      context: context,
      ref: ref,
      provider: provider,
    );

    final user = _authRepository.currentUser;
    if (user != null) {
      state = AsyncValue.data(user);
      return true;
    } else {
      state = AsyncValue.error('소셜 로그인 실패', StackTrace.current);
      return false;
    }
  }

  // 로그아웃
  Future<void> logout(WidgetRef ref) async {
    state = const AsyncValue.loading();
    await _authRepository.clearToken(ref);
    _messageRepository.disconnect();    // 웹소켓 disconnect & 구독 일괄 제거
    state = const AsyncValue.data(null);
  }
}

final authProvider =
    AsyncNotifierProvider<AuthViewModel, AppUser?>(AuthViewModel.new);
