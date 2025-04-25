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

  AuthNotifier(this.ref) : super(AuthState.loading()) {
    _init();
  }

  Future<void> _init() async {
    final authRepo = ref.read(authRepositoryProvider);
    final restored = await authRepo.restoreFromToken();

    // state = restored ? AuthStatus.authenticated : AuthStatus.unauthenticated;

    if (restored && authRepo.currentUser != null) {
      state = AuthState.authenticated(authRepo.currentUser!);
    } else {
      state = AuthState.unauthenticated();
    }

    // 이후에도 유저 정보가 바뀌면 반영
    authRepo.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    });
  }

  // Future<void> updateProfileImage(String newUrl) async {
  //   final repo = ref.read(authRepositoryProvider);
  //   final user = repo.currentUser;
  //
  //   if (user != null) {
  //     final updatedUser = user.copyWith(
  //       profileImageUrl: newUrl,
  //       hasProfileImage: newUrl.isNotEmpty,
  //     );
  //     repo.setUser(updatedUser); // 내부 스트림도 업데이트
  //     state = AuthState.authenticated(updatedUser);
  //   }
  // }
}

// 로그인 상태 (StateNotifier)
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
