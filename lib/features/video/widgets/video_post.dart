import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:video_player/video_player.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int pageIndex;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.pageIndex,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  static const List<String> videoUrls = [
    'assets/videos/dreaming.mp4',
    'assets/videos/no_barf_but_yarn.mp4',
    'assets/videos/smiling_after_mom.mp4',
    'assets/videos/what_are_you_looking_at_mom.mp4',
  ];

  late final VideoPlayerController _videoPlayerController;

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset(videoUrls[widget.pageIndex % 4]);

    await _videoPlayerController.initialize();
    _videoPlayerController.play();
    setState(() {});

    _videoPlayerController.addListener(_onVideoChange);
  }

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized &&
        _videoPlayerController.value.duration ==
            _videoPlayerController.value.position) {
      widget.onVideoFinished();
    }
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: _videoPlayerController.value.isInitialized
              ? VideoPlayer(_videoPlayerController)
              : Container(
                  color: Colors.black,
                  child: const Center(
                    child: Text(
                      "No more videos to display. \nYou've seen all of 'em.",
                      style: TextStyle(
                        fontSize: Sizes.size20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
