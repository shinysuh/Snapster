import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/feed/providers/feed_providers.dart';
import 'package:snapster_app/features/feed/repositories/feed_repository.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';

class FeedViewModel extends FamilyAsyncNotifier<List<VideoPostModel>, String> {
  late final FeedRepository _feedRepository;
  late final String userId;

  @override
  FutureOr<List<VideoPostModel>> build(String arg) async {
    _feedRepository = ref.read(feedRepositoryProvider);
    userId = arg;
    final data = await getPublicUserFeeds(userId);
    return data;
  }

  Future<List<VideoPostModel>> getPublicUserFeeds(String userId) async {
    return await _feedRepository.getPublicUserFeeds(userId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final newData = await getPublicUserFeeds(userId);
      state = AsyncValue.data(newData);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final feedViewModelProvider =
    AsyncNotifierProvider.family<FeedViewModel, List<VideoPostModel>, String>(
        FeedViewModel.new);
