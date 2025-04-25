import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

class AuthState {
  final AuthStatus status;
  final AppUser? user;

  const AuthState._(this.status, this.user);

  factory AuthState.loading() => const AuthState._(AuthStatus.loading, null);
  factory AuthState.authenticated(AppUser user) => AuthState._(AuthStatus.authenticated, user);
  factory AuthState.unauthenticated() => const AuthState._(AuthStatus.unauthenticated, null);
}