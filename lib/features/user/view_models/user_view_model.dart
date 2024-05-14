import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/user/models/user_profile_model.dart';
import 'package:tiktok_clone/features/user/repository/user_repository.dart';

class UserViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _repository;

  @override
  FutureOr<UserProfileModel> build() {
    _repository = ref.read(userRepository);
    return UserProfileModel.empty();
  }

  Future<void> createUserProfile(UserCredential credential) async {
    if (credential.user == null) {
      throw Exception('Account not created');
    }

    state = const AsyncValue.loading();

    final profile = UserProfileModel(
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? 'Anonymous',
      email: credential.user!.email ?? 'undefined',
      bio: 'undefined',
      link: 'undefined',
    );

    // firestore
    await _repository.createProfile(profile);
    // firebase
    state = AsyncValue.data(profile);
  }
}

final userProvider = AsyncNotifierProvider<UserViewModel, UserProfileModel>(
  () => UserViewModel(),
);
