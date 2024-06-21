import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/video/models/video_model.dart';
import 'package:tiktok_clone/features/video/repositories/video_repository.dart';

// Async - Because it's fetching values from APIs
class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  late final VideoRepository _repository;

  List<VideoModel> _list = [
    // VideoModel.sample(title: 'First Video'),
    // VideoModel.sample(title: 'Second Video'),
    // VideoModel.sample(title: 'Third Video'),
    // VideoModel.sample(title: 'Fourth Video'),
    // VideoModel.sample(title: 'Fifth Video'),
  ];

  // void uploadVideo() async {
  //   state = const AsyncValue.loading(); // loading 상태 강제 유발
  //   await Future.delayed(const Duration(seconds: 2));
  //
  //   final newVideo = VideoModel.sample(title: '${DateTime.now()}');
  //   _list = [..._list, newVideo];
  //   // _list = [..._list];
  //
  //   state = AsyncValue.data(_list);
  // }

  Future<List<VideoModel>> _fetchVideos({
    int? lastItemCreatedAt,
  }) async {
    final result =
        await _repository.fetchVideos(lastItemCreatedAt: lastItemCreatedAt);
    final videos = result.docs.map(
      (doc) => VideoModel.fromJson(doc.data()),
    );
    print(videos.map((e) => e.title));
    return videos.toList();
  }

  // FutureOr => Future 또는 Model 반환
  @override
  FutureOr<List<VideoModel>> build() async {
    // calling the API here
    // await Future.delayed(const Duration(seconds: 3));
    // throw Exception("Wasn't able to fetch videos");

    _repository = ref.read(videoRepository);

    _list = await _fetchVideos(lastItemCreatedAt: null);
    return _list;
  }

  Future<void> fetchNextPage() async {
    final nextPage =
        await _fetchVideos(lastItemCreatedAt: _list.last.createdAt);
    state = AsyncValue.data([..._list, ...nextPage]);
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
