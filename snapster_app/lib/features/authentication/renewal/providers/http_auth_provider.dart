import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:snapster_app/features/authentication/renewal/providers/auth_status_provider.dart';
import 'package:snapster_app/features/authentication/renewal/providers/token_storage_provider.dart';
import 'package:snapster_app/features/authentication/renewal/repositories/http_auth_repository.dart';
import 'package:snapster_app/features/authentication/renewal/services/http_auth_service.dart';
import 'package:snapster_app/features/authentication/renewal/services/i_auth_service.dart';
import 'package:snapster_app/features/chat/notification/providers/fcm_token_providers.dart';

// IAuthService 서비스 구현체 주입 (HTTP 호출 담당)
final httpAuthServiceProvider = Provider<IAuthService>(
  (ref) => HttpAuthService(client: http.Client()),
);

// 저장소 - AuthRepository (토큰 저장/복원/스트림 관리)
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(
      authService: ref.read(httpAuthServiceProvider),
      fcmTokenUtil: ref.read(fcmTokenUtilProvider),
      tokenStorageService: ref.read(tokenStorageServiceProvider),
    ));

// boolean 로그인 여부
final isLoggedInProvider = Provider<bool>((ref) {
  final status = ref.watch(authStateProvider);
  return status.status == AuthStatus.authenticated;
});

// final isLoggedInProvider = Provider<bool>((ref) {
//   final user = ref.watch(authStateProvider).asData?.value;
//   return user != null;
// });

// final authStateProvider = StreamProvider<AppUser?>((ref) {
//   return ref.watch(authRepositoryProvider).authStateChanges;
// });
