import 'package:snapster_app/common/widgets/navigation/views/main_navigation_screen.dart';
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/authentication/views/login/login_screen.dart';
import 'package:snapster_app/features/authentication/views/sign_up/sign_up_screen.dart';
import 'package:snapster_app/features/authentication/views/splash_screen.dart';
import 'package:snapster_app/features/user/views/user_profile_form_screen.dart';

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
