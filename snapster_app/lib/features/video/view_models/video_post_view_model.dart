import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/providers/firebase_auth_provider.dart';
import 'package:snapster_app/features/user/models/app_user_model.dart';
import 'package:snapster_app/features/video/repositories/video_repository.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<void, String> {
  late final VideoRepository _repository;
  late final String _videoId;
  late final AppUser? _user;

  @override
  FutureOr<void> build(String arg) {
    _videoId = arg;
    _repository = ref.read(videoRepository);
    _user = ref.read(firebaseAuthServiceProvider).currentUser;
  }

  Future<void> toggleLikeVideo(String thumbnailUrl) async {
    await _repository.toggleLikeVideo(
      userId: _user!.userId,
      videoId: _videoId,
      thumbnailUrl: thumbnailUrl,
    );
  }

  Future<bool> isLiked() async {
    return _repository.isLiked(videoId: _videoId, userId: _user!.userId);
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, void, String>(
  () => VideoPostViewModel(),
);
