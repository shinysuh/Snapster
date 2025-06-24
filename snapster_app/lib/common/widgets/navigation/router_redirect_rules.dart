import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/widgets/navigation/views/main_navigation_screen.dart';
import 'package:snapster_app/features/authentication/renewal/providers/auth_status_provider.dart';
import 'package:snapster_app/features/authentication/views/login/login_screen.dart';
import 'package:snapster_app/features/authentication/views/signup/sign_up_screen.dart';
import 'package:snapster_app/features/authentication/views/splash_screen.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/views/user_profile_form_screen.dart';

String? getRouterRedirect(AsyncValue<AppUser?> asyncUser, String loc) {
// 1) 로딩 중엔 리디렉션 하지 않음
  if (asyncUser.isLoading) {
    return null;
  }
  // 2) 에러 시 로그인 페이지로
  if (asyncUser.hasError) {
    return LoginScreen.routeURL;
  }

  // 3) 정상 값(unwrapped)
  final user = asyncUser.value; // AppUser?
  final status = _statusFromUser(user);

  return getRedirectionLocation(status, loc);
}

/// 현재 auth 상태와 현재 위치(loc)를 기반으로 리디렉션 경로를 반환
String? getRedirectionLocation(AuthStatus status, String loc) {
  // 예외 페이지들
  final isSplash = loc == Splashscreen.routeURL;
  final isAuthPage =
      loc == SignUpScreen.routeURL || loc == LoginScreen.routeURL;
  // 사용자 정보 업데이트 페이지
  final isUpdatePage = loc == UserProfileFormScreen.routeURL;

  // 로딩 중에는 리디렉션 액션 X
  if (status == AuthStatus.loading) return null;
  final isLoggedIn = status == AuthStatus.authenticated;

  // 로그아웃 상태(토큰 X) → 인증(로그인) 페이지로
  if (!isLoggedIn && !isSplash && !isAuthPage) {
    return LoginScreen.routeURL; // 로그인 페이지로 이동
  }

  // 프로필 편집은 홈 리디렉션 예외
  if (isLoggedIn && isUpdatePage) {
    return null;
  }

  // 로그인 상태(토큰 O) → 홈으로
  if (isLoggedIn && (isSplash || isAuthPage)) {
    return MainNavigationScreen.homeRouteURL; // 홈 화면으로 이동
  }

  return null; // 다른 경우에는 이동하지 않음
}

AuthStatus _statusFromUser(AppUser? user) {
  if (user == null) return AuthStatus.unauthenticated;
  return AuthStatus.authenticated;
}
