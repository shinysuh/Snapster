import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/video/models/video_model.dart';

// Async - Because it's fetching values from APIs
class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [
    VideoModel(title: 'First Video'),
    VideoModel(title: 'Second Video'),
    VideoModel(title: 'Third Video'),
    VideoModel(title: 'Fourth Video'),
    VideoModel(title: 'Fifth Video'),
  ];

  // FutureOr => Future 또는 Model 반환
  @override
  FutureOr<List<VideoModel>> build() async {
    // calling the API here
    await Future.delayed(const Duration(seconds: 3));

    throw Exception("Wasn't able to fetch videos");

    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  () => TimelineViewModel(),
);
