import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:snapster_app/features/authentication/old/providers/firebase_auth_provider.dart';
import 'package:snapster_app/features/user/view_models/user_view_model.dart';
import 'package:snapster_app/features/video_old/models/video_model.dart';
import 'package:snapster_app/features/video_old/repositories/video_repository.dart';
import 'package:snapster_app/utils/exception_handlers/error_snack_bar.dart';

class VideoUploadViewModel extends AsyncNotifier<void> {
  late final VideoRepository _videoRepository;

  @override
  FutureOr<void> build() {
    _videoRepository = ref.read(videoRepository);
  }

  Future<void> uploadVideo({
    required BuildContext context,
    required File video,
    required String title,
    required String description,
  }) async {
    final authRepo = ref.read(firebaseAuthServiceProvider);
    final user = authRepo.currentUser;
    final userProfile = ref.read(userProvider).value;

    if (!authRepo.isLoggedIn || userProfile == null) {
      authRepo.signOut(context);
      showSessionErrorSnack(context);
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      int createdAt = DateTime.now().millisecondsSinceEpoch;
      final task = await _videoRepository.uploadVideoFile(
        video,
        user!.userId,
        createdAt.toString(),
      );

      if (task.metadata != null) {
        await _videoRepository.saveVideo(
          VideoModel(
            id: '',
            title: title,
            description: description,
            tags: [],
            fileUrl: await task.ref.getDownloadURL(),
            thumbnailURL: '',
            userDisplayName: userProfile!.username,
            userId: user.userId,
            likes: 0,
            comments: 0,
            createdAt: createdAt,
          ),
        );

        if (!context.mounted) return;
        context.pop();
        context.pop();
      }
    });
  }
}

final videoUploadProvider = AsyncNotifierProvider<VideoUploadViewModel, void>(
  () => VideoUploadViewModel(),
);
