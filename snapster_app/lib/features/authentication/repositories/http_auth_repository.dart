import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:snapster_app/constants/authorization.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/authentication/services/token_storage_service.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

class AuthRepository {
  final IAuthService _authService;
  final _controller = StreamController<AppUser?>.broadcast();
  final TokenStorageService _tokenStorageService;

  AppUser? _currentUser;

  AuthRepository({
    required IAuthService authService,
    TokenStorageService? tokenStorageService,
  })  : _authService = authService,
        _tokenStorageService = tokenStorageService ?? TokenStorageService() {
    restoreFromToken();
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
  Future<bool> restoreFromToken() async {
    final token = await _tokenStorageService.readToken();
    debugPrint('📌 token: $token');

    if (token != null) {
      try {
        final user = await _authService.getUserFromToken(token);
        debugPrint('📌 user111: ${user.displayName}');
        _setUser(user);
        return true;
      } catch (e) {
        await _tokenStorageService.deleteToken();
        _setUser(null);
      }
    }
    return false;
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

    await _tokenStorageService.saveToken(token);
    debugPrint('✅ 토큰 저장 완료: $token');

    final user = await verifyAndSetUserFromToken(token);
    return user != null;
  }

  // 로그인 시, 토큰 저장 -> 사용자 정보 복구
  Future<void> storeToken(String token) async {
    await _tokenStorageService.saveToken(token);
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
    await _tokenStorageService.deleteToken();
    debugPrint('✅ 로그 아웃 완료');
    _setUser(null);
  }
}
