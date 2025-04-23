import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:snapster_app/features/authentication/repositories/auth_repository.dart';
import 'package:snapster_app/features/authentication/repositories/firebase_authentication_repository.dart';
import 'package:snapster_app/features/authentication/services/http_auth_service.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

// IAuthService 구현체 (HTTP 호출 담당)
final httpAuthServiceProvider = Provider<IAuthService>(
  (ref) => HttpAuthService(client: http.Client()),
);

// AuthRepository (토큰 저장/복원/스트림 관리)
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(
      authService: ref.read(httpAuthServiceProvider),
      storage: const FlutterSecureStorage(),
    ));

// 로그인 상태 스트림 (앱 전체에서 watch 가능)
// Stream 은 변화가 바로 반영됨 (watch)
final authStateProvider = StreamProvider<AppUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(authStateProvider).asData?.value;
  return user != null;
});

// TODO - 제거 예정
final firebaseAuthServiceProvider = Provider(
  (ref) => FirebaseAuthenticationRepository(),
);

// TODO - 제거 예정
// final authState = StreamProvider((ref) {
//   final repository = ref.read(firebaseAuthServiceProvider);
//   return repository.authStateChanges();
// });
