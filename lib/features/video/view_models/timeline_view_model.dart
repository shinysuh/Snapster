import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/video/models/video_model.dart';

// Async - Because it's fetching values from APIs
class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [
    VideoModel.sample(title: 'First Video'),
    VideoModel.sample(title: 'Second Video'),
    VideoModel.sample(title: 'Third Video'),
    VideoModel.sample(title: 'Fourth Video'),
    VideoModel.sample(title: 'Fifth Video'),
  ];

  void uploadVideo() async {
    state = const AsyncValue.loading(); // loading 상태 강제 유발
    await Future.delayed(const Duration(seconds: 2));

    final newVideo = VideoModel.sample(title: '${DateTime.now()}');
    _list = [..._list, newVideo];

    state = AsyncValue.data(_list);
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    // calling the API here
    await Future.delayed(const Duration(seconds: 3));
    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
