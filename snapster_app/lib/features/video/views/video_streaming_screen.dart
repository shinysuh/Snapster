import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/features/video/views/widgets/video_streaming_player.dart';
import 'package:snapster_app/utils/theme_mode.dart';

class VideoStreamingScreen extends ConsumerStatefulWidget {
  final List<VideoPostModel> videos;
  final int initialIndex;

  const VideoStreamingScreen({
    super.key,
    required this.videos,
    required this.initialIndex,
  });

  @override
  ConsumerState<VideoStreamingScreen> createState() =>
      _VideoStreamingScreenState();
}

class _VideoStreamingScreenState extends ConsumerState<VideoStreamingScreen> {
  late final PageController _pageController;
  late List<VideoPostModel> _orderedVideos;

  @override
  void initState() {
    super.initState();

    _orderedVideos = [
      ...widget.videos.sublist(widget.initialIndex),
      ...widget.videos.sublist(0, widget.initialIndex),
    ];

    _pageController = PageController(initialPage: 0);
  }

  void _onVideoFinished() {
    final nextPage = _pageController.page!.toInt() + 1;

    if (nextPage >= _orderedVideos.length) {
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: isDarkMode(context) ? Colors.black : Colors.white,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _orderedVideos.length,
        itemBuilder: (context, index) {
          final video = _orderedVideos[index];
          return VideoStreamingPlayer(
            isEmpty: _orderedVideos.isEmpty,
            pageIndex: index,
            video: video,
            onVideoFinished: _onVideoFinished,
          );
        },
      ),
    );
  }
}
