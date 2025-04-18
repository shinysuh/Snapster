import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snapster_app/features/authentication/initializers/token_auth_initializer.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';

class AuthRepository {
  static const _tokenKey = TokenAuthInitializer.authTokenKey;

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

  void _setUser(AppUser? user) {
    _currentUser = user;
    _controller.add(user);
  }

  // kakao login -> 백인드에서 JWT 받아와서 저장 -> 사용자 정보 조회
  Future<bool> signInWithKakao(String accessToken) async {
    final token = await _authService.signInWithKakao(accessToken);
    await _storage.write(key: _tokenKey, value: token);

    final user = await _authService.getUserFromToken(token);
    _setUser(user);
    return true;
  }

  Future<void> signOut() async {
    // await _authService.signOut();
    await _storage.delete(key: _tokenKey);
    _setUser(null);
  }

  // 딥링크 토큰 처리
  Future<bool> storeTokenFromUriAndRestoreAuth(Uri uri) async {
    bool hasSucceed = false;
    final token = uri.queryParameters['accessToken'];
    if (token == null) return hasSucceed;

    await _storage.write(key: _tokenKey, value: token);
    try {
      final user = await _authService.getUserFromToken(token);
      _setUser(user);
      hasSucceed = true;
    } catch (e) {
      hasSucceed = false;
      debugPrint("딥링크 토큰 에러: $e");
    }
    return hasSucceed;
  }


  //
  // //
  // bool get isLoggedIn => _authService.isLoggedIn;
  //
  // Stream<AppUser?> authStatedChange() => _authService.authStateChanges();
  //
  // Future<void> signUp(String email, String password) async {
  //   await _authService.signUp(email, password);
  // }
  //
  // Future<void> signIn(String email, String password) async {
  //   await _authService.signIn(email, password);
  // }
  //
  // Future<void> signOut(BuildContext context) async {
  //   await _authService.signOut(context);
  // }
  //
  // Future<void> signInWithGithub() async {
  //   await _authService.signInWithGithub();
  // }
  //
  // Future<void> signInWithGoogle() async {
  //   await _authService.signInWithGoogle();
  // }
  //
  // Future<void> signInWithApple() async {
  //   await _authService.signInWithApple();
  // }
  //
  // Future<void> checkLoginUser(BuildContext context) async {
  //   await _authService.checkLoginUser(context);
  // }

  Future<AppUser?> verifyAndSetUserFromToken(String token) async {
    // TODO: 서버에 token 유효성 확인 요청

    // 임시 로직
    final user = AppUser(uid: 'dummy', email: 'jenna@qwer.qwer');

    // authStateProvider에서 감지 가능하게 상태 업데이트 필요 시, 여기서 처리
    return user;
  }
}
