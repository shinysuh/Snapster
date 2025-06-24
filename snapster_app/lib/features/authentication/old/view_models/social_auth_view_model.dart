import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/widgets/navigation/views/main_navigation_screen.dart';
import 'package:snapster_app/features/authentication/old/providers/firebase_auth_provider.dart';
import 'package:snapster_app/features/authentication/old/repositories/firebase_authentication_repository.dart';
import 'package:snapster_app/features/onboarding/interests_screen.dart';
import 'package:snapster_app/utils/exception_handlers/error_snack_bar.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class SocialAuthViewModel extends AsyncNotifier<void> {
  // late final IAuthService _authProvider;
  late final FirebaseAuthenticationRepository _authProvider;

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

// OAuth 2.0
// void launchOAuthSignIn(String provider) async {
//   final Uri url = Uri.parse('${ApiInfo.oauthBaseUrl}/$provider');
//
//   if (await canLaunchUrl(url)) {
//     await launchUrl(url, mode: LaunchMode.externalApplication);
//   } else {
//     throw 'Could not launch $url';
//   }
// }
}

final socialAuthProvider = AsyncNotifierProvider<SocialAuthViewModel, void>(
  () => SocialAuthViewModel(),
);
