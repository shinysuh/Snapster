import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/renewal/providers/http_auth_provider.dart';
import 'package:snapster_app/features/authentication/renewal/providers/token_storage_provider.dart';
import 'package:snapster_app/features/authentication/renewal/repositories/http_auth_repository.dart';
import 'package:snapster_app/features/authentication/renewal/services/token_storage_service.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/chatroom/repositories/chatroom_repository.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:snapster_app/features/chat/stomp/repositories/stomp_repository.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/providers/user_profile_provider.dart';
import 'package:snapster_app/features/user/repository/http_user_profile_repository.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';

class AuthViewModel extends AsyncNotifier<AppUser?> {
  late final AuthRepository _authRepository;
  late final TokenStorageService _tokenStorageService;
  late final HttpUserProfileRepository _userProfileRepository;
  late final ChatroomRepository _chatroomRepository;
  late final StompRepository _stompRepository;

  @override
  FutureOr<AppUser?> build() async {
    _authRepository = ref.read(authRepositoryProvider);
    _tokenStorageService = ref.read(tokenStorageServiceProvider);
    _userProfileRepository = ref.read(userProfileRepositoryProvider);
    _chatroomRepository = ref.read(chatroomRepositoryProvider);
    _stompRepository = ref.read(stompRepositoryProvider);

    return await initialize();
  }

  Future<AppUser?> initialize() async {
    // 1) 토큰 복구 시도
    final restored = await _authRepository.restoreFromToken();
    final user = restored ? _authRepository.currentUser : null;

    final accessToken = await _tokenStorageService.readToken();
    if (user != null && accessToken != null) {
      await _setOnline(); // redis 온라인 상태 저장
      final chatrooms = await getAllParticipatingChatrooms();
      final chatroomIds = chatrooms.map((room) => room.id).toList();
      // 2) WebSocket 연결 & 참여 중인 채팅방 일괄 구독
      _stompRepository.initializeForUser(accessToken, chatroomIds);
    }
    return user;
  }

  Future<List<ChatroomModel>> getAllParticipatingChatrooms() async {
    return await runFutureWithExceptionLogs<List<ChatroomModel>>(
      errorPrefix: '채팅방 목록 조회',
      requestFunction: () async => _chatroomRepository.getAllChatroomsByUser(),
      fallback: [],
    );
  }

  // 딥링크 토큰 로그인
  Future<bool> loginWithDeepLink(Uri uri, WidgetRef ref) async {
    state = const AsyncValue.loading();

    final success =
        await _authRepository.storeTokenFromUriAndRestoreAuth(uri, ref);
    if (success) {
      await _setOnline();
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
      await _setOnline();
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
    await _setOffline();
    await _authRepository.clearToken(ref);
    _stompRepository.disconnect(); // 웹소켓 disconnect & 구독 일괄 제거
    state = const AsyncValue.data(null);
  }

  Future<void> _setOnline() async {
    await _userProfileRepository.syncRedisOnline();
  }

  Future<void> _setOffline() async {
    await _userProfileRepository.syncRedisOffline();
  }
}

final authProvider =
    AsyncNotifierProvider<AuthViewModel, AppUser?>(AuthViewModel.new);
