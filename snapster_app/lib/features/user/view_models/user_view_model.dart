import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/old/providers/firebase_auth_provider.dart';
import 'package:snapster_app/features/authentication/old/view_models/signup_view_model.dart';
import 'package:snapster_app/features/authentication/renewal/services/i_auth_service.dart';
import 'package:snapster_app/features/user/models/user_profile_model.dart';
import 'package:snapster_app/features/user/repository/user_repository.dart';
import 'package:snapster_app/utils/exception_handlers/error_snack_bar.dart';

class UserViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _userRepository;
  late final IAuthService _authProvider;

  late final UserProfileModel loginUser;

  @override
  FutureOr<UserProfileModel> build() async {
    // await Future.delayed(const Duration(seconds: 2));

    _userRepository = ref.read(userRepository);
    _authProvider = ref.read(firebaseAuthServiceProvider);

    if (_authProvider.isLoggedIn) {
      final profile =
          await _userRepository.findProfile(_authProvider.currentUser!.userId);
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
      name: form['name'] ?? form['username'] ?? '',
      username: form['username'] ?? credential.user!.displayName,
      email: credential.user!.email ?? '',
      bio: '',
      link: '',
      birthday: form['birthday'] ?? '1900-01-01',
      hasProfileImage: false,
    );

    // firestore
    await _userRepository.createProfile(profile);
    // firebase
    state = AsyncValue.data(profile);
  }

  Future<void> updateProfile(
    BuildContext context,
    UserProfileModel profile,
  ) async {
    await _authProvider.checkLoginUser(context);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () async => await _userRepository.updateProfile(profile.uid, profile));
  }

  Future<String> findUsername(
    BuildContext context,
    String uid,
  ) async {
    var profile = await _userRepository.findProfile(uid);

    if (profile == null && context.mounted) {
      showCustomErrorSnack(context, '존재하지 않는 대상입니다.');
      throw Exception();
    }

    return profile!['username'] ?? '';
  }

  Future<void> onAvatarUploaded(UserProfileModel profile) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasProfileImage: true));
    await _userRepository.patchProfile(state.value!.uid, {'hasProfileImage': true});
  }

  Future<void> onAvatarDeleted(UserProfileModel profile) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasProfileImage: false));
    await _userRepository.patchProfile(state.value!.uid, {'hasProfileImage': false});
  }

  Future<void> checkLoginUser(BuildContext context) async {
    var isLoggedIn = ref.read(firebaseAuthServiceProvider).isLoggedIn;
    if (!isLoggedIn) {
      _authProvider.signOut(context);
      showSessionErrorSnack(context);
      throw Exception();
    }
  }
}

final userProvider = AsyncNotifierProvider<UserViewModel, UserProfileModel>(
  () => UserViewModel(),
);
