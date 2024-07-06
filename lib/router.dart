import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/constants/navigation_tabs.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/authentication/views/login_screen.dart';
import 'package:tiktok_clone/features/authentication/views/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/models/chat_partner_model.dart';
import 'package:tiktok_clone/features/inbox/views/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chatroom_user_list_screen.dart';
import 'package:tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';
import 'package:tiktok_clone/features/user/views/user_profile_form_screen.dart';
import 'package:tiktok_clone/features/video/views/video_recording_screen.dart';

/*
      TikTok Clone route description
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
  return GoRouter(
    initialLocation: ChatsScreen.routeURL, // TODO - 원복
    // initialLocation: MainNavigationScreen.homeRouteURL,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepository).isLoggedIn;
      return !isLoggedIn &&
              state.subloc != SignUpScreen.routeURL &&
              state.subloc != LoginScreen.routeURL
          ? SignUpScreen.routeURL
          : null;
    },
    routes: [
      // GoRoute(
      //   path: '/',
      //   builder: (context, state) => const VideoRecordingScreen(),
      // ),
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
                chatroom: chatroom as ChatPartnerModel,
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
      // GoRoute(
      //   name: UsernameScreen.routeName,
      //   path: UsernameScreen.routeURL,
      //   pageBuilder: (context, state) => CustomTransitionPage(
      //       transitionsBuilder: (context, animation, secondaryAnimation, child) =>
      //           FadeTransition(
      //             opacity: animation,
      //             child: ScaleTransition(
      //               scale: animation,
      //               child: child,
      //             ),
      //           ),
      //       child: const UsernameScreen()),
      // ),
      // GoRoute(
      //   path: '/user/:username',
      //   builder: (context, state) {
      //     // 쿼리파라미터로 데이터 넘기기
      //     final username = state.params['username'] ?? '';
      //     // e.g. '/user/:username?show=likes'
      //     final param = state.queryParams['show'] ?? '';
      //     return UserProfileScreen(username: username, show: param);
      //   },
      // ),
    ],
  );
});
