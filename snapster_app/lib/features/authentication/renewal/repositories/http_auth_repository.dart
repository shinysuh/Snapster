import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/widgets/navigation/router.dart';
import 'package:snapster_app/constants/api_info.dart';
import 'package:snapster_app/features/authentication/renewal/constants/authorization.dart';
import 'package:snapster_app/features/authentication/renewal/providers/auth_status_provider.dart';
import 'package:snapster_app/features/authentication/renewal/services/i_auth_service.dart';
import 'package:snapster_app/features/authentication/renewal/services/token_storage_service.dart';
import 'package:snapster_app/features/authentication/renewal/views/oauth_web_view_screen.dart';
import 'package:snapster_app/features/authentication/views/splash_screen.dart';
import 'package:snapster_app/features/chat/notification/models/fcm_token_model.dart';
import 'package:snapster_app/features/chat/notification/utils/fcm_token_util.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthRepository {
  final IAuthService _authService;
  final _controller = StreamController<AppUser?>.broadcast();
  final FcmTokenUtil _fcmTokenUtil;
  final TokenStorageService _tokenStorageService;

  AppUser? _currentUser;

  AuthRepository({
    required IAuthService authService,
    required FcmTokenUtil fcmTokenUtil,
    TokenStorageService? tokenStorageService,
  })  : _authService = authService,
        _fcmTokenUtil = fcmTokenUtil,
        _tokenStorageService = tokenStorageService ?? TokenStorageService() {
    restoreFromToken();
  }

  Stream<AppUser?> get authStateChanges => _controller.stream;

  AppUser? get currentUser => _currentUser;

  bool get isLoggedIn => _currentUser != null;

  // 사용자 상태 업데이트
  void setUser(AppUser? user) {
    _currentUser = user;
    _controller.add(user);
    // debugPrint(
    //     '######### user set: $user, ${user?.userId}, ${user?.profileImageUrl}');
  }

  // 앱 시작 시, 토큰이 있으면 사용자 정보 복구
  Future<bool> restoreFromToken() async {
    final token = await _tokenStorageService.readToken();
    // debugPrint('######### ✅token: $token}');
    if (token != null) {
      try {
        final user = await _authService.getUserFromToken(token);
        setUser(user);
        return true;
      } catch (e) {
        await _tokenStorageService.deleteToken();
        setUser(null);
      }
    }
    return false;
  }

  // 토큰을 사용해 사용자 정보 복구
  Future<AppUser?> _verifyAndSetUserFromToken(String token) async {
    try {
      // 서버에 토큰 유효성 검증 요청
      final user = await _authService.getUserFromToken(token);
      setUser(user);

      if (token.isNotEmpty) {
        _fcmTokenUtil.listenFcmTokenRefresh(token);
      }

      return user;
    } catch (e) {
      debugPrint('토큰 유효성 검증 실패: $e');
      setUser(null);
      // todo - login 페이지로 이동 필요
      return null;
    }
  }

  // 딥링크로부터 토큰을 받아 와서 저장 -> 사용자 정보 복구
  Future<bool> storeTokenFromUriAndRestoreAuth(Uri uri, WidgetRef ref) async {
    final token = uri.queryParameters[Authorizations.accessTokenKey];
    if (token == null) return false;
    return await _storeToken(token);
    //
    // await _tokenStorageService.saveToken(token);
    //
    // final user = await verifyAndSetUserFromToken(token);
    //
    // final success = user != null;
    // if (success) ref.invalidate(authStateProvider);
    // return success;
  }

  Future<void> socialLoginWithProvider({
    required BuildContext context,
    required WidgetRef ref,
    required String provider,
  }) async {
    final url = '${ApiInfo.oauthBaseUrl}/$provider';

    debugPrint("Platform.isAndroid : ${Platform.isAndroid}");

    // TODO : 개발 완료 후 제거 (7일마다 갱신 필요)
    if (Platform.isAndroid) {
      String fcmToken = '';
      if (provider == 'kakao') {
        // kakao
        fcmToken =
            "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMCIsInVzZXJuYW1lIjoiSmVubmEiLCJpc3MiOiJzbmFwc3Rlci1hcHAiLCJpYXQiOjE3NTEyNjQxNDIsImV4cCI6MTc1MTg2ODk0Mn0.PvgeUtl3N4wsMSXNzlOk5NuNYvfeFAVnS_PPG_gvjYhE2QFR69-4uCLNbQFZbzimsuqUKG0ltftiFVu051tqGw";
      } else if (provider == 'google') {
        // google
        fcmToken =
            "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIxMSIsInVzZXJuYW1lIjoi7ISc7Iug7JiBIiwiZW1haWwiOiJzaGlueXN1aDE5OTJAZ21haWwuY29tIiwiaXNzIjoic25hcHN0ZXItYXBwIiwiaWF0IjoxNzUxMjY0MTE1LCJleHAiOjE3NTE4Njg5MTV9.i53Nb6y6UTDbig_O1-hxOGTPR9F7Fi-ZdokVo6SM1EpQranZF-5PJswULUnzfxN84qGJfWpsl2wtUw7XFRoyiA";
      }

      await _storeToken(fcmToken);
      return;
    }

    if (url.startsWith("https") || Platform.isAndroid) {
      _inAppLoginWithProvider(
        context: context,
        ref: ref,
        url: url,
      );
    } else {
      _launchOAuthSignIn(url);
    }
  }

  // OAuth 2.0 브라우저 로그인
  void _launchOAuthSignIn(String urlStr) async {
    final Uri url = Uri.parse(urlStr);

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  // OAuth 2.0 인앱 로그인
  Future<void> _inAppLoginWithProvider({
    required BuildContext context,
    required WidgetRef ref,
    required String url,
  }) async {
    final token = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (_) => OAuthWebViewPage(initialUrl: url),
      ),
    );
    if (token != null) {
      final success = await _storeToken(token);
      if (success) ref.invalidate(authStateProvider);
    }
  }

  // 로그인 시, 토큰 저장 -> 사용자 정보 복구
  Future<bool> _storeToken(String token) async {
    await _tokenStorageService.saveToken(token);
    final user = await _verifyAndSetUserFromToken(token);
    if (user != null) {
      _registerFcmToken(token);
      debugPrint('로그인 성공: ${user.username}');
      return true;
    } else {
      debugPrint('로그인 실패');
      return false;
    }
  }

  // FCM 토큰 서버 등록
  Future<void> _registerFcmToken(String accessToken) async {
    final fcmToken = await _fcmTokenUtil.generateFcmToken();
    if (fcmToken != null) {
      await _authService.registerFcmToken(accessToken, fcmToken);
      await _fcmTokenUtil.storeFcmToken(fcmToken);
      debugPrint('FCM 토큰 발급 성공');
    }
    // debugPrint('============ FCM 토큰: $fcmToken');
  }

  // 로그아웃 시, 토큰 삭제 및 사용자 상태 초기화(null) => 초기 페이지로 이동
  Future<void> clearToken(WidgetRef ref) async {
    try {
      final accessToken = await _tokenStorageService.readToken();
      await _tokenStorageService.deleteToken(); // access token 삭제
      await _clearFcmToken(accessToken); // fcm 토큰 서버 삭제 + 로컬 삭제
      setUser(null); // 사용자 상태 초기화
      ref.invalidate(authStateProvider); // 상태 초기화
      ref.read(routerProvider).go(Splashscreen.routeURL); // 초기 화면으로 이동
    } catch (e) {
      debugPrint('로그아웃 도중 오류 발생: $e');
    }
  }

  Future<void> _clearFcmToken(String? accessToken) async {
    final fcmToken = await _fcmTokenUtil.loadFcmToken();
    if (accessToken != null && fcmToken != null) {
      await _authService.deleteFcmToken(
          accessToken: accessToken,
          fcm: FcmTokenModel(userId: '', fcmToken: fcmToken));
      await _fcmTokenUtil.clearFcmToken();
    }
  }
}
