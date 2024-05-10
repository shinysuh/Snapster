import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthenticationRepository _authRepository;

  @override
  FutureOr<void> build() {
    // 현재 build()는 _authRepository 를 initialize 하는 역할 이외에는 안함
    _authRepository = ref.read(authRepository);
  }

  Future<void> signUp() async {
    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);
    state = await AsyncValue.guard(
      () async => await _authRepository.signUp(
        form['email'],
        form['password'],
      ),
    );
  }
}

// StateProvider => 외부에서 modify 가능한 값 expose
final signUpForm = StateProvider((ref) => {});

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);
