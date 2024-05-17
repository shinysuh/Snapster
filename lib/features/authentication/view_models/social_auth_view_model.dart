import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/widgets/navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/onboarding/interests_screen.dart';
import 'package:tiktok_clone/utils/base_exception_handler.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';

class SocialAuthViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepository);
  }

  Future<void> githubSignIn(BuildContext context, bool isNewUser) async {
    signInBySocial(context, isNewUser, _repository.githubSingIn);
  }

  Future<void> appleSignIn(BuildContext context, bool isNewUser) async {
    signInBySocial(context, isNewUser, _repository.appleSingIn);
  }

  Future<void> googleSignIn(BuildContext context, bool isNewUser) async {
    signInBySocial(context, isNewUser, _repository.googleSingIn);
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
