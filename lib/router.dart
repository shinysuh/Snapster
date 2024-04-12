import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/email_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/user/user_profile_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: SignUpScreen.routeName,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: UsernameScreen.routeName,
      path: UsernameScreen.routeURL,
      pageBuilder: (context, state) => CustomTransitionPage(
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              ),
          child: const UsernameScreen()),
    ),
    GoRoute(
      path: EmailScreen.routeName,
      builder: (context, state) {   // extra 로 데이터 넘기기
        final args = state.extra as EmailScreenArgs;
        return EmailScreen(
          username: args.username,
        );
      },
    ),
    GoRoute(
      path: '/user/:username',
      builder: (context, state) {   // 쿼리파라미터로 데이터 넘기기
        final username = state.params['username'] ?? '';
        final param = state.queryParams['show'] ?? '';    // e.g. '/user/:username?show=likes'
        return UserProfileScreen(username: username, show: param);
      },
    ),
  ],
);
