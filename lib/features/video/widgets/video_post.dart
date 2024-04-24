import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/profile_images.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/video/widgets/video_button.dart';
import 'package:tiktok_clone/features/video/widgets/video_caption.dart';
import 'package:tiktok_clone/features/video/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished, onTapVolume;
  final int pageIndex;
  final bool isMuted;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.pageIndex,
    required this.onTapVolume,
    required this.isMuted,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  static const List<String> videoUrls = [
    'assets/videos/no_barf_but_yarn.mp4',
    'assets/videos/face_changer.mp4',
    'assets/videos/smiling_after_mom.mp4',
    'assets/videos/dreaming.mp4',
    'assets/videos/what_are_you_looking_at_mom.mp4',
  ];
  late final VideoPlayerController _videoPlayerController;
  late final AnimationController _animationController;

  final _animationDuration = const Duration(milliseconds: 200);

  bool _isPaused = false;
  bool _isLiked = false;

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
    _animationController.dispose();
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.asset(
        videoUrls[widget.pageIndex % videoUrls.length]);
    // initialize
    await _videoPlayerController.initialize();

    // 영상 반복 재생
    await _videoPlayerController.setLooping(true);
    // 영상 자동 넘김 시 필요
    // _videoPlayerController.addListener(_onVideoChange);

    _videoPlayerController.setVolume(widget.isMuted ? 0 : 1);

    setState(() {
      _isPaused = false;
    });
  }

  void _onVideoChange() {
    if (_videoPlayerController.value.isInitialized &&
        _videoPlayerController.value.duration ==
            _videoPlayerController.value.position) {
      widget.onVideoFinished();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;

    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !_videoPlayerController.value.isPlaying) {
      _videoPlayerController.play();
    }

    if (info.visibleFraction < 1 && _videoPlayerController.value.isPlaying) {
      _togglePause();
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

  void _onTapVolume() {
    setState(() {
      var muted = !widget.isMuted;
      widget.onTapVolume(muted);
      _videoPlayerController.setVolume(muted ? 0 : 1);
    });
  }

  void _onTapLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
  }

  void _onTapComments(BuildContext context) async {
    if (_videoPlayerController.value.isPlaying) _togglePause();

    await showModalBottomSheet(
      context: context,
      // backgroundColor: transparent 설정으로 Scaffold의 설정이 보일 수 있게 됨 (borderRadius 도 마찬가지)
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => VideoComments(),
    );

    _togglePause();
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
          Positioned(
            bottom: 25,
            right: 15,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _onTapVolume,
                  child: FaIcon(
                    widget.isMuted
                        ? FontAwesomeIcons.volumeXmark
                        : FontAwesomeIcons.volumeHigh,
                    color: Colors.white,
                    size: Sizes.size24,
                  ),
                ),
                Gaps.v24,
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: profileImage,
                  child: const Text(
                    'Jenna',
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: _onTapLike,
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidHeart,
                    iconColor: _isLiked ? Colors.red : Colors.white,
                    text: S.of(context).likeCount(3233),
                  ),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onTapComments(context),
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidCommentDots,
                    iconColor: Colors.white,
                    text: S.of(context).commentCount(823522),
                  ),
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.share,
                  iconColor: Colors.white,
                  text: S.of(context).share,
                ),
                Gaps.v20,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
