import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapster_app/constants/authorization.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

class AuthRepository {
  static const _tokenKey = Authorizations.tokenKey;

  final IAuthService _authService;
  final FlutterSecureStorage _storage;
  final _controller = StreamController<AppUser?>.broadcast();

  AppUser? _currentUser;

  AuthRepository({
    required IAuthService authService,
    FlutterSecureStorage? storage,
  })  : _authService = authService,
        _storage = storage ?? const FlutterSecureStorage() {
    _restoreFromToken();
  }

  Stream<AppUser?> get authStateChanges => _controller.stream;

  AppUser? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  // 사용자 상태 업데이트
  void _setUser(AppUser? user) {
    _currentUser = user;
    _controller.add(user);
  }

  // 앱 시작 시, 토큰이 있으면 사용자 정보 복구
  Future<void> _restoreFromToken() async {
    final token = await _storage.read(key: _tokenKey);
    if (token != null) {
      try {
        final user = await _authService.getUserFromToken(token);
        _setUser(user);
      } catch (e) {
        await _storage.delete(key: _tokenKey);
        _setUser(null);
      }
    }
  }

  // 토큰을 사용해 사용자 정보 복구
  Future<AppUser?> verifyAndSetUserFromToken(String token) async {
    try {
      // 서버에 토큰 유효성 검증 요청
      final user = await _authService.getUserFromToken(token);
      _setUser(user);
      return user;
    } catch (e) {
      debugPrint('토큰 유효성 검증 실패: $e');
      _setUser(null);
      return null;
    }
  }

  // 딥링크로부터 토큰을 받아 와서 저장 -> 사용자 정보 복구
  Future<bool> storeTokenFromUriAndRestoreAuth(Uri uri) async {
    final token = uri.queryParameters[Authorizations.accessTokenKey];
    if (token == null) return false;

    await _storage.write(key: _tokenKey, value: token);
    debugPrint('✅ 토큰 저장 완료: $token');

    final user = await verifyAndSetUserFromToken(token);
    return user != null;
  }

  // 로그인 시, 토큰 저장 -> 사용자 정보 복구
  Future<void> storeToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    debugPrint('✅ 로그인 완료: $token');

    final user = await verifyAndSetUserFromToken(token);
    if (user != null) {
      debugPrint('로그인 성공: ${user.email}');
    } else {
      debugPrint('로그인 실패');
    }
  }

  // 로그아웃 시, 토큰 삭제 및 사용자 상태 초기화(null)
  Future<void> clearToken() async {
    await _storage.delete(key: _tokenKey);
    debugPrint('✅ 로그 아웃 완료');
    _setUser(null);
  }
}
