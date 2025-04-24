import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snapster_app/common/widgets/navigation/main_navigation_screen.dart';
import 'package:snapster_app/constants/navigation_tabs.dart';
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/authentication/providers/http_auth_provider.dart';
import 'package:snapster_app/features/authentication/views/login/login_screen.dart';
import 'package:snapster_app/features/authentication/views/sign_up/sign_up_screen.dart';
import 'package:snapster_app/features/authentication/views/splash_screen.dart';
import 'package:snapster_app/features/inbox/models/chat_partner_model.dart';
import 'package:snapster_app/features/inbox/views/activity_screen.dart';
import 'package:snapster_app/features/inbox/views/chat_detail_screen.dart';
import 'package:snapster_app/features/inbox/views/chatroom_user_list_screen.dart';
import 'package:snapster_app/features/inbox/views/chats_screen.dart';
import 'package:snapster_app/features/onboarding/interests_screen.dart';
import 'package:snapster_app/features/user/models/user_profile_model.dart';
import 'package:snapster_app/features/user/views/user_profile_form_screen.dart';
import 'package:snapster_app/features/video/views/video_recording_screen.dart';

/*
      Snapster route description
          ** GoRouter(url 미변경) && Navigator 1(url 변경) 동시 사용
o
      /  Sign Up    (GoRouter)
          (Navigator)
        /
        /
        /
        /

      /login  Log In    (GoRouter)
          (Navigator)
        /login  Form

      /onboarding    (GoRouter)
          (Navigator)
        /onboarding  Interest
        /onboarding  Tutorial

      /home -> home    (GoRouter)
      /discover -> discover
      /inbox -> inbox
        /activity
        /chats
          /:chatroomId

      /profile -> profile

 */
final routerProvider = Provider((ref) {
  // ref.watch(authState);   // 변화가 생기변 provider 가 rebuild 됨
  final authStatus = ref.watch(authStatusProvider);

  return GoRouter(
    initialLocation: Splashscreen.routeURL,
    redirect: (context, state) {
      final loc = state.subloc;
      // 예외 페이지들
      final isSplash = loc == Splashscreen.routeURL;
      final isAuthPage =
          loc == SignUpScreen.routeURL || loc == LoginScreen.routeURL;

      // 로딩 중에는 리디렉션 액션 X
      if(authStatus == AuthStatus.loading) return null;

      final isLoggedIn = authStatus == AuthStatus.authenticated;

      final user = ref.read(authRepositoryProvider).currentUser;

      debugPrint('📌 user: ${user?.displayName}');
      debugPrint('📌 isLoggedIn: $isLoggedIn');

      // 토큰이 없으면 로그인/회원가입 페이지로 리다이렉션
      if (!isLoggedIn && !isSplash && !isAuthPage) {
        return SignUpScreen.routeURL; // 로그인 페이지로 이동
      }

      // 토큰이 있으면 홈 화면으로 리다이렉션
      if (isLoggedIn && (isSplash || isAuthPage)) {
        return MainNavigationScreen.homeRouteURL; // 홈 화면으로 이동
      }

      return null; // 다른 경우에는 이동하지 않음
    },
    routes: [
      GoRoute(
        name: Splashscreen.routeName,
        path: Splashscreen.routeURL,
        builder: (context, state) => const Splashscreen(),
      ),
      GoRoute(
        name: UserProfileFormScreen.routeName,
        path: UserProfileFormScreen.routeURL,
        builder: (context, state) {
          var profile = state.extra != null
              ? state.extra as UserProfileModel
              : UserProfileModel.empty();
          return UserProfileFormScreen(profile: profile);
        },
      ),
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeURL,
        builder: (context, state) => const SignUpScreen(),
        // nested routes
        // routes: [
        //   GoRoute(
        //     name: UsernameScreen.routeName,
        //     path: UsernameScreen.routeURL,
        //     builder: (context, state) => const UsernameScreen(),
        //     routes: [
        //       GoRoute(
        //         name: EmailScreen.routeName,
        //         path: EmailScreen.routeURL,
        //         builder: (context, state) {
        //           // extra 로 데이터 넘기기
        //           final args = state.extra as EmailScreenArgs;
        //           return EmailScreen(
        //             username: args.username,
        //           );
        //         },
        //         routes: [
        //           GoRoute(
        //             name: PasswordScreen.routeName,
        //             path: PasswordScreen.routeURL,
        //             builder: (context, state) {
        //               // extra 로 데이터 넘기기
        //               return const PasswordScreen();
        //             },
        //             routes: [
        //               GoRoute(
        //                 name: BirthdayScreen.routeName,
        //                 path: BirthdayScreen.routeURL,
        //                 builder: (context, state) {
        //                   // extra 로 데이터 넘기기
        //                   return const BirthdayScreen();
        //                 },
        //               ),
        //             ],
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ],
      ),
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeURL,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: InterestScreen.routeName,
        path: InterestScreen.routeURL,
        builder: (context, state) => const InterestScreen(),
      ),
      GoRoute(
        // 파라미터 값 한정
        // path 의 괄호() 안에 값 지정 시 (|으로 구분), 해당 항목들에 한해서만 :tab 이 반응
        // (home|discover|camera|inbox|profile)
        path: '/:tab(${tabs.join('|')})',
        name: MainNavigationScreen.routeName,
        builder: (context, state) {
          final tab = state.params['tab'] ?? tabs[0];
          return MainNavigationScreen(
            tab: tab,
          );
        },
      ),
      GoRoute(
        name: ActivityScreen.routeName,
        path: ActivityScreen.routeURL,
        builder: (context, state) => const ActivityScreen(),
      ),
      GoRoute(
        name: ChatsScreen.routeName,
        path: ChatsScreen.routeURL,
        builder: (context, state) => const ChatsScreen(),
        routes: [
          GoRoute(
            name: ChatDetailScreen.routeName,
            path: ChatDetailScreen.routeURL,
            builder: (context, state) {
              final id = state.params['chatroomId'] ?? '';
              final chatroom = state.extra;
              return ChatDetailScreen(
                chatroomId: id,
                chatroomBasicInfo: chatroom as ChatPartnerModel,
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: VideoRecordingScreen.routeName,
        path: VideoRecordingScreen.routeURL,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const VideoRecordingScreen(),
          transitionDuration: const Duration(milliseconds: 150),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final position = Tween(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation);
            return SlideTransition(
              position: position,
              child: child,
            );
          },
        ),

        //     CustomTransitionPage(
        //   child: VideoRecordingScreen(),
        //   transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //     final position = Tween(
        //       begin: const Offset(0, 1),
        //       end: Offset.zero,
        //     ).animate(animation);
        //     return SlideTransition(
        //       position: position,
        //       child: child,
        //     );
        //   },
        // ),
      ),
      GoRoute(
        name: ChatroomUserListScreen.routeName,
        path: ChatroomUserListScreen.routeURL,
        builder: (context, state) => const ChatroomUserListScreen(),
      ),
    ],
  );
});
