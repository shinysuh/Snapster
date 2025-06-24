import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/renewal/providers/http_auth_provider.dart';
import 'package:snapster_app/features/authentication/renewal/repositories/http_auth_repository.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

class AuthViewModel extends AsyncNotifier<AppUser?> {
  late final AuthRepository _authRepository;

  @override
  FutureOr<AppUser?> build() async {
    _authRepository = ref.read(authRepositoryProvider);
    // 초기 상태 - 복구 시도
    final restored = await _authRepository.restoreFromToken();
    return restored ? _authRepository.currentUser : null;
  }

  // 딥링크 토큰 로그인
  Future<bool> loginWithDeepLink(Uri uri, WidgetRef ref) async {
    state = const AsyncValue.loading();

    final success =
        await _authRepository.storeTokenFromUriAndRestoreAuth(uri, ref);
    if (success) {
      state = AsyncValue.data(_authRepository.currentUser);
    } else {
      // state = const AsyncValue.error('로그인 실패');
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
      // state = const AsyncValue.error('소셜 로그인 실패');
      return false;
    }
  }

  // 로그아웃
  Future<void> logout(WidgetRef ref) async {
    state = const AsyncValue.loading();
    await _authRepository.clearToken(ref);
    state = const AsyncValue.data(null);
  }
}

final authProvider =
    AsyncNotifierProvider<AuthViewModel, AppUser?>(AuthViewModel.new);
