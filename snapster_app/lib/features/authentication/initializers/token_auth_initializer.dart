import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapster_app/constants/authorization.dart';
import 'package:snapster_app/features/authentication/repositories/auth_repository.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

class TokenAuthInitializer {
  final FlutterSecureStorage _storage;
  final AuthRepository _authRepository;

  TokenAuthInitializer({
    required FlutterSecureStorage storage,
    required AuthRepository authRepository,
  })  : _storage = storage,
        _authRepository = authRepository;

  // 앱 시작 시 호출
  Future<AppUser?> checkAndRestoreAuth() async {
    final token = await _storage.read(key: Authorizations.tokenKey);

    if (token == null) return null;

    // TODO - verifyAndSetUserFromToken() 나중에 토큰 유효성 검증 필요 (ex. 만료 확인)
    final user = await _authRepository.verifyAndSetUserFromToken(token);

    return user;
  }

  Future<bool> storeTokenFromUriAndRestoreAuth(Uri uri) async {
    await storeTokenFromUri(uri);
    final user = await checkAndRestoreAuth();
    return user != null;
  }

  // DeepLink로부터 토큰 저장
  Future<void> storeTokenFromUri(Uri uri) async {
    final token = uri.queryParameters['accessToken'];
    if (token != null) {
      await _storage.write(key: Authorizations.tokenKey, value: token);
      debugPrint('✅ [TokenAuthInitializer] 토큰 저장 완료: $token');
    }
  }

  // 로그인 성공 시 호출
  Future<void> storeToken(String token) async {
    await _storage.write(key: Authorizations.tokenKey, value: token);
    debugPrint('✅ [storeToken] 로그인 완료: $token');
  }

  // 로그아웃 시 호출
  Future<void> clearToken() async {
    await _storage.delete(key: Authorizations.tokenKey);
    debugPrint('✅ [clearToken] 로그 아웃 완료');
  }
}
