import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/providers/auth_status_provider.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/user/providers/user_profile_provider.dart';
import 'package:snapster_app/features/user/repository/http_user_profile_repository.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler_2.dart';

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
    String errMsgPrefix = '사용자 정보 업데이트 실패';

    await runFutureWithExceptionHandler(
        context: context,
        errMsgPrefix: errMsgPrefix,
        callBackFunction: () async {
          _userProfileRepository.updateUserProfile(updateUser);
          // authStateProvider 업데이트
          ref.read(authStateProvider.notifier).updateCurrentUser(updateUser);
        });

    // try {
    //   _userProfileRepository.updateUserProfile(updateUser);
    //   // authStateProvider 업데이트
    //   ref.read(authStateProvider.notifier).updateCurrentUser(updateUser);
    // } on DioException catch (e) {
    //   if (context.mounted) handleDioException(context, e, errMsgPrefix);
    // } catch (e) {
    //   if (context.mounted) basicExceptions(context, e, errMsgPrefix);
    // }
  }
}

final httpUserProfileProvider =
    AsyncNotifierProvider<HttpUserProfileViewModel, void>(
  () => HttpUserProfileViewModel(),
);
