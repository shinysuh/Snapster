import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/renewal/providers/auth_status_provider.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/providers/user_profile_provider.dart';
import 'package:snapster_app/features/user/repository/http_user_profile_repository.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';

class HttpUserProfileViewModel extends AsyncNotifier<void> {
  late final HttpUserProfileRepository _userProfileRepository;
  late final AppUser? _currentUser;

  @override
  FutureOr<void> build() {
    _userProfileRepository = ref.read(userProfileRepositoryProvider);
    _currentUser = ref.watch(authStateProvider).user;
  }

  Future<List<AppUser>> getAllOtherUsers(BuildContext context) async {
    return await runFutureWithExceptionHandler<List<AppUser>>(
      context: context,
      errorPrefix: '사용자 목록 조회',
      requestFunction: () async => _userProfileRepository.getAllOtherUsers(),
      fallback: [],
    );
  }

  Future<void> updateUserProfile(
      BuildContext context, AppUser updateUser) async {
    await runFutureVoidWithExceptionHandler(
        context: context,
        errorPrefix: '사용자 정보 업데이트',
        requestFunction: () async {
          _userProfileRepository.updateUserProfile(updateUser);
          // authStateProvider 업데이트
          ref.read(authStateProvider.notifier).updateCurrentUser(updateUser);
        });
  }

  Future<void> setUserOnline(BuildContext context) async {
    await runFutureVoidWithExceptionHandler(
        context: context,
        errorPrefix: '사용자 Redis 온리인 세팅',
        requestFunction: () async {
          _userProfileRepository.syncRedisOnline();
        });
  }

  Future<void> setUserOffline(BuildContext context) async {
    await runFutureVoidWithExceptionHandler(
        context: context,
        errorPrefix: '사용자 Redis 오프라인 처리',
        requestFunction: () async {
          _userProfileRepository.syncRedisOnline();
        });
  }
}

final httpUserProfileProvider =
    AsyncNotifierProvider<HttpUserProfileViewModel, void>(
  () => HttpUserProfileViewModel(),
);
