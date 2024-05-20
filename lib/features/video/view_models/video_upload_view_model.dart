import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/widgets/navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/user/view_models/user_view_model.dart';
import 'package:tiktok_clone/features/video/models/video_model.dart';
import 'package:tiktok_clone/features/video/repositories/video_repository.dart';
import 'package:tiktok_clone/utils/base_exception_handler.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';

class VideoUploadViewModel extends AsyncNotifier<void> {
  late final VideoRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(videoRepository);
  }

  Future<void> uploadVideo({
    required BuildContext context,
    required File video,
    required String title,
    required String description,
  }) async {
    final authRepo = ref.read(authRepository);
    final user = authRepo.user;
    final userProfile = ref.read(userProvider).value;

    if (!authRepo.isLoggedIn || userProfile == null) {
      authRepo.signOut(context);
      showSessionErrorSnack(context);
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      int createdAt = DateTime.now().millisecondsSinceEpoch;
      final task = await _repository.uploadVideoFile(
        video,
        user!.uid,
        createdAt.toString(),
      );

      if (task.metadata != null) {
        await _repository.saveVideo(
          VideoModel(
            title: title,
            description: description,
            fileUrl: await task.ref.getDownloadURL(),
            thumbnailURL: '',
            uploader: userProfile!.username,
            uploaderUid: user.uid,
            likes: 0,
            comments: 0,
            createdAt: createdAt,
          ),
        );

        if (!context.mounted) return;
        goRouteReplacementRoute(
          context: context,
          routeURL: MainNavigationScreen.homeRouteURL,
        );
      }
    });
  }
}

final videoUploadProvider = AsyncNotifierProvider<VideoUploadViewModel, void>(
  () => VideoUploadViewModel(),
);
