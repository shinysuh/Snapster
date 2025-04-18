import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/widgets/navigation/main_navigation_screen.dart';
import 'package:snapster_app/features/authentication/providers/auth_provider.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/features/onboarding/interests_screen.dart';
import 'package:snapster_app/utils/base_exception_handler.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialAuthViewModel extends AsyncNotifier<void> {
  late final IAuthService _authProvider;

  @override
  FutureOr<void> build() {
    _authProvider = ref.read(firebaseAuthServiceProvider);
  }

  Future<void> githubSignIn(BuildContext context, bool isNewUser) async {
    signInBySocial(context, isNewUser, _authProvider.signInWithGithub);
  }

  Future<void> appleSignIn(BuildContext context, bool isNewUser) async {
    signInBySocial(context, isNewUser, _authProvider.signInWithApple);
  }

  Future<void> googleSignIn(BuildContext context, bool isNewUser) async {
    signInBySocial(context, isNewUser, _authProvider.signInWithGoogle);
  }

  void launchKakaoSignIn() async {
    final Uri url =
        Uri.parse('http://localhost:8080/oauth2/authorization/kakao');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void signInBySocial(
      BuildContext context, bool isNewUser, Function targetSocialFunc) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await targetSocialFunc(),
    );

    if (!context.mounted) return;

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      goToRouteWithoutStack(
        context: context,
        location: isNewUser
            ? InterestScreen.routeURL
            : MainNavigationScreen.homeRouteURL,
      );
    }
  }
}

final socialAuthProvider = AsyncNotifierProvider<SocialAuthViewModel, void>(
  () => SocialAuthViewModel(),
);
