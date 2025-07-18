import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/features/video/widgets/video_streaming_player.dart';

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

    // _orderedVideos = [
    //   ...widget.videos.sublist(widget.initialIndex),
    //   ...widget.videos.sublist(0, widget.initialIndex),
    // ];
    //
    // _pageController = PageController(initialPage: 0);

    _orderedVideos = widget.videos;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _onVideoFinished() {
    // 자동 영상 넘김 설정
    // final nextPage = _pageController.page!.toInt() + 1;
    //
    // if (nextPage >= _orderedVideos.length) {
    // } else {
    //   _pageController.nextPage(
    //     duration: const Duration(milliseconds: 200),
    //     curve: Curves.linear,
    //   );
    // }
  }

  void _onVideoScrolled(int move) {
    final landingPage = _pageController.page!.toInt() + move;

    if (move == 1) {
      if (landingPage >= _orderedVideos.length) {
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      }
    } else {
      if (landingPage < 0) {
      } else {
        _pageController.previousPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      }
    }
  }

  Widget _getBackToFeedButton() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + Sizes.size8,
      left: 0,
      child: IconButton(
        icon: Icon(
          Icons.chevron_left,
          size: Sizes.size28,
          color: Colors.grey.shade600,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _orderedVideos.length,
            itemBuilder: (context, index) {
              final video = _orderedVideos[index];
              return VideoStreamingPlayer(
                isEmpty: _orderedVideos.isEmpty,
                pageIndex: index,
                video: video,
                // onVideoScrolled: _onVideoScrolled,
              );
            },
          ),
          _getBackToFeedButton(),
        ],
      ),
    );
  }
}
