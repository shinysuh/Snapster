import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/video/repositories/video_repository.dart';

class VideoPostViewModel extends FamilyAsyncNotifier<void, String> {
  late final VideoRepository _repository;
  late final _videoId;
  late final _user;

  @override
  FutureOr<void> build(String arg) {
    _videoId = arg;
    _repository = ref.read(videoRepository);
    _user = ref.read(authRepository).user;
  }

  Future<void> toggleLikeVideo() async {
    await _repository.toggleLikeVideo(videoId: _videoId, userId: _user!.uid);
  }

  Future<bool> isLiked() async {
    return _repository.isLiked(videoId: _videoId, userId: _user!.uid);
  }
}

final videoPostProvider =
    AsyncNotifierProvider.family<VideoPostViewModel, void, String>(
  () => VideoPostViewModel(),
);
