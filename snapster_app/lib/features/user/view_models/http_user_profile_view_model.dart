import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/authentication/providers/http_auth_provider.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/providers/user_profile_provider.dart';
import 'package:snapster_app/features/user/repository/http_user_profile_repository.dart';
import 'package:snapster_app/utils/base_exception_handler.dart';

class HttpUserProfileViewModel extends AsyncNotifier<void> {
  late final HttpUserProfileRepository _userProfileRepository;
  late final AppUser? _currentUser;

  @override
  FutureOr<void> build() {
    _userProfileRepository = ref.read(userProfileRepositoryProvider);
    _currentUser = ref.watch(authStateProvider).user;
  }

  Future<void> updateUserProfile(
      BuildContext context, AppUser updateUser) async {
    try {
      _userProfileRepository.updateUserProfile(updateUser);

      debugPrint('####### 사용자 정보 업데이트 성공');
      // authStateProvider 업데이트
      ref.read(authStateProvider.notifier).updateCurrentUser(updateUser);
    } catch (e) {
      final errMessage = '####### 사용자 정보 업데이트 실패: $e';
      if (context.mounted) {
        showCustomErrorSnack(context, errMessage);
      } else {
        debugPrint(errMessage);
      }
    }
  }
}

final httpUserProfileProvider =
    AsyncNotifierProvider<HttpUserProfileViewModel, void>(
  () => HttpUserProfileViewModel(),
);
