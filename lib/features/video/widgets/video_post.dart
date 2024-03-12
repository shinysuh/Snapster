import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/video/widgets/video_button.dart';
import 'package:tiktok_clone/features/video/widgets/video_caption.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

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

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  static const List<String> videoUrls = [
    'assets/videos/dreaming.mp4',
    'assets/videos/no_barf_but_yarn.mp4',
    'assets/videos/face_changer.mp4',
    'assets/videos/smiling_after_mom.mp4',
    'assets/videos/what_are_you_looking_at_mom.mp4',
  ];
  late final VideoPlayerController _videoPlayerController;
  late final AnimationController _animationController;

  final _animationDuration = const Duration(milliseconds: 200);

  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      // vsync: offscreen 애니메이션의 불필요한 리소스 사용 방지
      lowerBound: 1.0,
      upperBound: 2.0,
      value: 2.0,
      // default (설정하지 않으면 lowerBound 로 설정됨)
      duration: _animationDuration,
    );

    // ** AnimatedBuilder 를 사용하지 않을 때의 방법
    // _animationController.addListener(() {
    //   setState(() {});
    // });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset(videoUrls[widget.pageIndex % 4]);
    // initialize
    await _videoPlayerController.initialize();

    // 영상 반복 재생
    await _videoPlayerController.setLooping(true);
    // 영상 자동 넘김 시 필요
    // _videoPlayerController.addListener(_onVideoChange);

    setState(() {});
  }

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized &&
        _videoPlayerController.value.duration ==
            _videoPlayerController.value.position) {
      widget.onVideoFinished();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1 && !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }
  }

  void _togglePause() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController.play();
      _animationController.forward();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${widget.pageIndex}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
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
          Positioned.fill(
            child: GestureDetector(
              onTap: _togglePause,
            ),
          ),
          Positioned.fill(
            // IgnorePointer 클릭 이벤트가 해당 위젯을 무시하고 진행됨
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    // _animationController 의 값이 변경될 때마다 실행됨
                    return Transform.scale(
                      scale: _animationController.value,
                      child: child,
                    );
                  },
                  // child: Transform.scale(
                  // scale: _animationController.value,
                  child: AnimatedOpacity(
                    duration: _animationDuration,
                    opacity: _isPaused ? 1 : 0,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size72,
                    ),
                  ),
                  // ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 25,
            left: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '@jen',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v18,
                VideoCaption(),
              ],
            ),
          ),
          const Positioned(
            bottom: 25,
            right: 15,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQIAr03vzZt9XBfML_UrBmXt80NW0YTgnKV1CJo3mm8gw&s'),
                  child: Text(
                    'Jenna',
                  ),
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: '2.9M',
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidCommentDots,
                  text: '33K',
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: 'share',
                ),
                Gaps.v28,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
