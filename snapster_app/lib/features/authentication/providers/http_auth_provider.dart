import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/authentication/repositories/http_auth_repository.dart';
import 'package:snapster_app/features/authentication/services/http_auth_service.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/authentication/services/token_storage_service.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

// IAuthService 서비스 구현체 주입 (HTTP 호출 담당)
final httpAuthServiceProvider = Provider<IAuthService>(
  (ref) => HttpAuthService(client: http.Client()),
);

// 저장소 - AuthRepository (토큰 저장/복원/스트림 관리)
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(
      authService: ref.read(httpAuthServiceProvider),
      tokenStorageService: TokenStorageService(),
    ));

// boolean 로그인 여부
final isLoggedInProvider = Provider<bool>((ref) {
  final status = ref.watch(authStatusProvider);
  return status == AuthStatus.authenticated;
});

// 현재 로그인 사용자
final currentUserProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// final isLoggedInProvider = Provider<bool>((ref) {
//   final user = ref.watch(authStateProvider).asData?.value;
//   return user != null;
// });

// final authStateProvider = StreamProvider<AppUser?>((ref) {
//   return ref.watch(authRepositoryProvider).authStateChanges;
// });
