import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snapster_app/common/widgets/navigation/go_router_refresh_stream.dart';
import 'package:snapster_app/common/widgets/navigation/router_redirect_rules.dart';
import 'package:snapster_app/common/widgets/navigation/views/main_navigation_screen.dart';
import 'package:snapster_app/constants/navigation_tabs.dart';
import 'package:snapster_app/features/authentication/renewal/providers/auth_status_provider.dart';
import 'package:snapster_app/features/authentication/renewal/providers/http_auth_provider.dart';
import 'package:snapster_app/features/authentication/views/login/login_screen.dart';
import 'package:snapster_app/features/authentication/views/signup/sign_up_screen.dart';
import 'package:snapster_app/features/authentication/views/splash_screen.dart';
import 'package:snapster_app/features/chat/chatroom/models/chatroom_model.dart';
import 'package:snapster_app/features/chat/views/test_chat_detail_screen.dart';
import 'package:snapster_app/features/chat/views/test_chats_screen.dart';
import 'package:snapster_app/features/inbox/models/chat_partner_model.dart';
import 'package:snapster_app/features/inbox/views/activity_screen.dart';
import 'package:snapster_app/features/inbox/views/chat_detail_screen.dart';
import 'package:snapster_app/features/inbox/views/chatroom_user_list_screen.dart';
import 'package:snapster_app/features/inbox/views/chats_screen.dart';
import 'package:snapster_app/features/onboarding/interests_screen.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/views/user_profile_form_screen.dart';
import 'package:snapster_app/features/video_old/views/video_recording_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.read(authRepositoryProvider);
  return GoRouter(
    initialLocation: Splashscreen.routeURL,
    refreshListenable: GoRouterRefreshStream(authRepo.authStateChanges),
    redirect: (context, state) {
      return getRedirectionLocation(
        ref.read(authStateProvider).status,
        state.subloc,
      );
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
          var user =
              state.extra != null ? state.extra as AppUser : AppUser.empty();
          return UserProfileFormScreen(user: user);
        },
      ),
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeURL,
        builder: (context, state) => const SignUpScreen(),
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
        name: TestChatsScreen.routeName,
        path: TestChatsScreen.routeURL,
        builder: (context, state) => const TestChatsScreen(),
        routes: [
          GoRoute(
            name: TestChatDetailScreen.routeName,
            path: TestChatDetailScreen.routeURL,
            builder: (context, state) {
              final id = state.params['chatroomId'] ?? 0;
              final chatroom = state.extra;
              return TestChatDetailScreen(
                chatroomId: int.parse(id.toString()),
                chatroom: chatroom as ChatroomModel,
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
      ),
      GoRoute(
        name: ChatroomUserListScreen.routeName,
        path: ChatroomUserListScreen.routeURL,
        builder: (context, state) => const ChatroomUserListScreen(),
      ),
    ],
  );
});
