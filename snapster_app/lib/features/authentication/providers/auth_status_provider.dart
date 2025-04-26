// 로그인 상태 스트림 (앱 전체에서 watch 가능)
// Stream 은 변화가 바로 반영됨 (watch)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/auth_state_model.dart';
import 'package:snapster_app/features/authentication/providers/http_auth_provider.dart';

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

    // 이후에도 유저 정보가 바뀌면 반영
    authRepo.authStateChanges.listen((user) {
      if (_disposed) return;
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    });
  }
}

// 로그인 상태 (StateNotifier)
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
