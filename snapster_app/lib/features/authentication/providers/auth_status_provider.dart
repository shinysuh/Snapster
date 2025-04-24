// 로그인 상태 스트림 (앱 전체에서 watch 가능)
// Stream 은 변화가 바로 반영됨 (watch)
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/providers/http_auth_provider.dart';

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
}

class AuthNotifier extends StateNotifier<AuthStatus> {
  final Ref ref;

  AuthNotifier(this.ref) : super(AuthStatus.loading) {
    _init();
  }

  Future<void> _init() async {
    final authRepo = ref.read(authRepositoryProvider);
    final restored = await authRepo.restoreFromToken();

    state = restored ? AuthStatus.authenticated : AuthStatus.unauthenticated;
  }
}

// 로그인 상태 (StateNotifier)
final authStatusProvider = StateNotifierProvider<AuthNotifier, AuthStatus>((ref) {
  return AuthNotifier(ref);
});
