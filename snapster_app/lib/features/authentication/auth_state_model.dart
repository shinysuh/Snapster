import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

class AuthState {
  final AuthStatus status;
  final AppUser? user;

  const AuthState._(this.status, this.user);

  factory AuthState.loading() => const AuthState._(AuthStatus.loading, null);

  factory AuthState.authenticated(AppUser user) =>
      AuthState._(AuthStatus.authenticated, user);

  factory AuthState.unauthenticated() =>
      const AuthState._(AuthStatus.unauthenticated, null);

  // 기존 상태를 유지하면서 user만 업데이트
  AuthState copyWithUser(AppUser newUser) {
    return AuthState._(status, newUser);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState
        && other.status == status
        && other.user == user;   // 상태와 사용자 정보가 동일한지 비교
  }

  @override
  int get hashCode => status.hashCode ^ user.hashCode;
}
