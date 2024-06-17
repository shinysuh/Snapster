import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/user/view_models/user_view_model.dart';
import 'package:tiktok_clone/features/video/models/video_model.dart';
import 'package:tiktok_clone/features/video/repositories/video_repository.dart';
import 'package:tiktok_clone/utils/base_exception_handler.dart';

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
      final task = await _videoRepository.uploadVideoFile(
        video,
        user!.uid,
        createdAt.toString(),
      );

      if (task.metadata != null) {
        var uploadedVideo = await _videoRepository.saveVideo(
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

        var videoId = uploadedVideo.id;

        // 비동기 처리
        // await 하면 유저가 너무 오래 기다리게 됨(백단으로 보내는 게 제일 좋음..)
        saveThumbnailInfo(videoId);

        if (!context.mounted) return;
        context.pop();
        context.pop();
      }
    });
  }

  Future<void> saveThumbnailInfo(String videoId) async {
    while (true) {
      await Future.delayed(const Duration(milliseconds: 500));

      var video = await _videoRepository.findVideo(videoId);
      var thumbnailURL = video?['thumbnailURL'] ?? '';

      if (thumbnailURL.isNotEmpty) {
        await _videoRepository.saveVideoAndThumbnail(
          video!,
          videoId,
          thumbnailURL,
        );
        break;
      }
    }
  }
}

final videoUploadProvider = AsyncNotifierProvider<VideoUploadViewModel, void>(
  () => VideoUploadViewModel(),
);
