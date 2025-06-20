import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/feed/providers/feed_providers.dart';
import 'package:snapster_app/features/feed/repositories/feed_repository.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/utils/exception_handlers/base_exception_handler.dart';

class FeedViewModel extends FamilyAsyncNotifier<List<VideoPostModel>, String> {
  late final FeedRepository _feedRepository;
  late final String _userId;

  @override
  FutureOr<List<VideoPostModel>> build(String arg) async {
    _feedRepository = ref.read(feedRepositoryProvider);
    _userId = arg;
    final data = await getPublicUserFeeds(_userId);
    return data;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final newData = await getPublicUserFeeds(_userId);
      state = AsyncValue.data(newData);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<List<VideoPostModel>> getPublicUserFeeds(String userId) async {
    return await runFutureWithExceptionLogs<List<VideoPostModel>>(
      errorPrefix: '사용자 피드 조회',
      requestFunction: () async => _feedRepository.getPublicUserFeeds(userId),
      fallback: [],
    );
  }
}

final feedViewModelProvider =
    AsyncNotifierProvider.family<FeedViewModel, List<VideoPostModel>, String>(
  FeedViewModel.new,
);
