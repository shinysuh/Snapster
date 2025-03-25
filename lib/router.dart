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

final routerProvider = Provider((ref) {
  return GoRouter(
    initialLocation: MainNavigationScreen.homeRouteURL,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepository).isLoggedIn;
      return !isLoggedIn &&
              state.subloc != SignUpScreen.routeURL &&
              state.subloc != LoginScreen.routeURL
          ? SignUpScreen.routeURL
          : null;
    },
    routes: [
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
      ),
      GoRoute(
        name: ChatroomUserListScreen.routeName,
        path: ChatroomUserListScreen.routeURL,
        builder: (context, state) => const ChatroomUserListScreen(),
      ),
    ],
  );
});
