import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/repositories/authentication_repository.dart';
import 'package:snapster_app/features/onboarding/interests_screen.dart';
import 'package:snapster_app/features/user/view_models/user_view_model.dart';
import 'package:snapster_app/utils/base_exception_handler.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepository;

  @override
  FutureOr<void> build() {
    // 현재 build()는 _authRepository 를 initialize 하는 역할 이외에는 안함
    _authRepository = ref.read(authRepository);
  }

  Future<void> signUp(BuildContext context) async {
    state = const AsyncValue.loading();

    final form = ref.read(signUpForm);
    final users = ref.read(userProvider.notifier);

    state = await AsyncValue.guard(
      () async {
        final credential = await _authRepository.emailSignUp(
          form['email'],
          form['password'],
        );

        await users.createUserProfile(credential);
      },
    );

    if (!context.mounted) return;

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      goToRouteNamedWithoutStack(
        context: context,
        routeName: InterestScreen.routeName,
      );
    }
  }
}

// StateProvider => 외부에서 modify 가능한 값 expose
final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
