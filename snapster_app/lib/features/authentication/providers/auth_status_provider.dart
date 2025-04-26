// 로그인 상태 스트림 (앱 전체에서 watch 가능)
// Stream 은 변화가 바로 반영됨 (watch)
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/auth_state_model.dart';
import 'package:snapster_app/features/authentication/providers/http_auth_provider.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  bool _disposed = false;

  AuthNotifier(this.ref) : super(AuthState.loading()) {
    _init();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> _init() async {
    final authRepo = ref.read(authRepositoryProvider);
    final restored = await authRepo.restoreFromToken();

    if (_disposed) return;
    // state = restored ? AuthStatus.authenticated : AuthStatus.unauthenticated;

    if (restored && authRepo.currentUser != null) {
      state = AuthState.authenticated(authRepo.currentUser!);
    } else {
      state = AuthState.unauthenticated();
    }

    // 로그인/로그아웃 상태 변경 감지
    authRepo.authStateChanges.listen((user) {
      if (_disposed) return;

      final currentStatus = state.status;
      final currentUser = state.user;

      if (user != null) {
        if (currentStatus != AuthStatus.authenticated ||
            currentUser?.userId != user.userId) {
          // 로그인 상태이거나, 다른 유저로 로그인한 경우에만 변경
          state = AuthState.authenticated(user);
        }
      } else {
        if (currentStatus != AuthStatus.unauthenticated) {
          state = AuthState.unauthenticated();
        }
      }
    });
  }

  // 프로필 정보만 업데이트 (status는 건드리지 않음)
  void updateCurrentUser(AppUser newUser) {
    if (_disposed) return;
    debugPrint('######### 사용자 업데이트 로직 접근');
    state = state.copyWithUser(newUser);
  }
}

// 로그인 상태 (StateNotifier)
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
