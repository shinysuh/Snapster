import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/authentication/view_models/signup_view_model.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';
import 'package:tiktok_clone/features/user/repository/user_repository.dart';
import 'package:tiktok_clone/utils/base_exception_handler.dart';

class UserViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;
  late final AuthenticationRepository _authRepository;

  late final UserProfileModel loginUser;

  @override
  FutureOr<UserProfileModel> build() async {
    // await Future.delayed(const Duration(seconds: 2));

    _userRepository = ref.read(userRepository);
    _authRepository = ref.read(authRepository);

    if (_authRepository.isLoggedIn) {
      final profile =
          await _userRepository.findProfile(_authRepository.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }

    return UserProfileModel.empty();
  }

  Future<void> createUserProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception('Account not created');
    }

    state = const AsyncValue.loading();
    final form = ref.read(signUpForm);

    final profile = UserProfileModel(
      uid: credential.user!.uid,
      name: form['name'] ?? '',
      username:
          credential.user!.displayName ?? form['username'] ?? form['name'],
      email: credential.user!.email ?? '',
      bio: '',
      link: '',
      birthday: form['birthday'] ?? '1900-01-01',
      hasAvatar: false,
    );

    // firestore
    await _userRepository.createProfile(profile);
    // firebase
    state = AsyncValue.data(profile);
  }

  Future<void> updateProfile(
      BuildContext context, UserProfileModel profile) async {
    await _authRepository.checkLoginUser(context);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () async => await _userRepository.updateProfile(profile.uid, profile));
  }

  Future<void> onAvatarUploaded(UserProfileModel profile) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _userRepository.patchProfile(state.value!.uid, {'hasAvatar': true});
  }

  Future<void> onAvatarDeleted(UserProfileModel profile) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: false));
    await _userRepository.patchProfile(state.value!.uid, {'hasAvatar': false});
  }

  Future<void> checkLoginUser(BuildContext context) async {
    var isLoggedIn = ref.read(authRepository).isLoggedIn;
    if (!isLoggedIn) {
      _authRepository.signOut(context);
      showSessionErrorSnack(context);
      throw Exception();
    }
  }
}

final userProvider = AsyncNotifierProvider<UserViewModel, UserProfileModel>(
  () => UserViewModel(),
);
