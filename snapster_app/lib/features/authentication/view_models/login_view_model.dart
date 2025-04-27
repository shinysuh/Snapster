import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/widgets/navigation/views/main_navigation_screen.dart';
import 'package:snapster_app/features/authentication/providers/firebase_auth_provider.dart';
import 'package:snapster_app/features/authentication/services/i_auth_service.dart';
import 'package:snapster_app/utils/exception_handlers/error_snack_bar.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class LoginViewModel extends AsyncNotifier<void> {
  late final IAuthService _authProvider;

  @override
  FutureOr<void> build() {
    _authProvider = ref.read(firebaseAuthServiceProvider);
  }

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async => await _authProvider.signIn(email, password),
    );

    if (!context.mounted) return;

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      goToRouteWithoutStack(
        context: context,
        location: MainNavigationScreen.homeRouteURL,
      );
    }
  }
}

final loginProvider = AsyncNotifierProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);
