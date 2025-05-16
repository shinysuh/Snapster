import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/models/video_model.dart';
import 'package:snapster_app/features/video/view_models/playback_config_view_model.dart';
import 'package:snapster_app/features/video/view_models/video_post_view_model.dart';
import 'package:snapster_app/features/video/views/widgets/video_button.dart';
import 'package:snapster_app/features/video/views/widgets/video_caption.dart';
import 'package:snapster_app/features/video/views/widgets/video_comments.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/profile_network_img.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  final bool isEmpty;
  final Function onVideoFinished;
  final int pageIndex;
  final VideoModel videoData;

  const VideoPost({
    super.key,
    required this.isEmpty,
    required this.onVideoFinished,
    required this.pageIndex,
    required this.videoData,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoPlayerController;
  late final AnimationController _animationController;

  final _animationDuration = const Duration(milliseconds: 200);

  late final String _videoId;
  bool _isPaused = false;
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;
  bool _isInitialized = false;

  /* Riverpod */
  late bool _isMuted = kIsWeb ? true : ref.watch(playbackConfigProvider).muted;
  late bool _showPlayButton = ref.watch(playbackConfigProvider).autoplay;

  @override
  void initState() {
    super.initState();
    _videoId = widget.videoData.id;
    _initLike();
    _initVideoPlayer();

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 2.0,
      value: 2.0,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _initLike() async {
    _likeCount = widget.videoData.likes;
    _commentCount = widget.videoData.comments;
    // todo - 나중에 새로 적용
    // _isLiked = await ref.read(videoPostProvider(_videoId).notifier).isLiked();
  }

  Future<void> _initVideoPlayer() async {
    try {
      // Use the videoUrl directly from videoData
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoData.fileUrl));

      // initialize
      await _videoPlayerController?.initialize();

      // 영상 반복 재생
      await _videoPlayerController?.setLooping(true);

      _videoPlayerController?.addListener(() {
        _videoPlayerController?.setVolume(_isMuted ? 0 : 1);
      });

      setState(() {
        _isPaused = !ref.read(playbackConfigProvider).autoplay;
        _isInitialized = true;
      });
    } catch (e) {
      // 에러 핸들링: 에러 메시지를 출력하거나, 에러 상태로 전환
      print('Error initializing video player: $e');
    }
  }

  void _toggleMuted() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _onChangePlaybackConfig() {
    if (!mounted) return;

    _videoPlayerController
        ?.setVolume(!ref.read(playbackConfigProvider).muted ? 0 : 1);
  }

  void _onVideoChange() {
    if (_videoPlayerController?.value.isInitialized == true &&
        _videoPlayerController?.value.duration ==
            _videoPlayerController?.value.position) {
      widget.onVideoFinished();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;

    if (info.visibleFraction == 1 &&
        !_isPaused &&
        !(_videoPlayerController?.value.isPlaying ?? false)) {
      if (ref.read(playbackConfigProvider).autoplay) {
        _videoPlayerController?.play();
      }
    }

    if (info.visibleFraction < 1 &&
        (_videoPlayerController?.value.isPlaying ?? false)) {
      _togglePause();
    }
  }

  void _togglePause() {
    if (!_showPlayButton) _showPlayButton = true;

    if (_videoPlayerController?.value.isPlaying ?? false) {
      _videoPlayerController?.pause();
      _animationController.reverse();
    } else {
      _videoPlayerController?.play();
      _animationController.forward();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onTapLike() {
    ref
        .read(videoPostProvider(_videoId).notifier)
        .toggleLikeVideo(widget.videoData.thumbnailURL);

    setState(() {
      !_isLiked ? _likeCount++ : _likeCount--; // db를 직접 찌르지 않음 -> 금전적 이유
      _isLiked = !_isLiked;
    });
  }

  void _onChangeCommentCount(int commentCount) {
    setState(() {
      _commentCount = commentCount;
    });
  }

  void _onTapComments(BuildContext context) async {
    if (_videoPlayerController?.value.isPlaying ?? false) _togglePause();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => VideoComments(
        videoId: _videoId,
        commentCount: _commentCount,
        onChangeCommentCount: _onChangeCommentCount,
      ),
    );

    _togglePause();
  }

  List<Widget> _getPageElements() {
    return [
      Positioned.fill(
        child: GestureDetector(
          onTap: _togglePause,
        ),
      ),
      Positioned.fill(
        child: IgnorePointer(
          child: Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _animationController.value,
                  child: child,
                );
              },
              child: _showPlayButton
                  ? AnimatedOpacity(
                      duration: _animationDuration,
                      opacity: _isPaused ? 1 : 0,
                      child: const FaIcon(
                        FontAwesomeIcons.play,
                        color: Colors.white,
                        size: Sizes.size72,
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ),
      Positioned(
        bottom: 25,
        left: 15,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '@${widget.videoData.userDisplayName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v18,
            if (widget.videoData.description.isNotEmpty)
              VideoCaption(
                description: widget.videoData.description,
                tags: widget.videoData.tags,
              ),
          ],
        ),
      ),
      Positioned(
        bottom: 25,
        right: 15,
        child: Column(
          children: [
            GestureDetector(
              onTap: _toggleMuted,
              child: FaIcon(
                _isMuted
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
              foregroundImage: getProfileImgByUserId(
                widget.videoData.userId,
                false,
              ),
            ),
            Gaps.v12,
            GestureDetector(
              onTap: _onTapLike,
              child: VideoButton(
                icon: FontAwesomeIcons.solidHeart,
                iconColor: _isLiked ? Colors.red : Colors.white,
                text: S.of(context).likeCount(_likeCount),
              ),
            ),
            Gaps.v24,
            GestureDetector(
              onTap: () => _onTapComments(context),
              child: VideoButton(
                icon: FontAwesomeIcons.solidCommentDots,
                iconColor: Colors.white,
                text: S.of(context).commentCount(_commentCount),
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
      )
    ];
  }

  TextStyle _getErrorContainerTextStyle() {
    return const TextStyle(
      fontSize: Sizes.size20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
      height: 1.8,
    );
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('${widget.pageIndex}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: widget.isEmpty
                ? Container(
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        S.of(context).noVideosToShow,
                        // "No more videos to display. \nYou've seen all of 'em.",
                        style: const TextStyle(
                          fontSize: Sizes.size20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : _isInitialized
                    ? VideoPlayer(_videoPlayerController!)
                    : Image.network(
                        widget.videoData.thumbnailURL,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.black,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator.adaptive(
                                  backgroundColor: Colors.white,
                                ),
                                Gaps.v20,
                                Text(
                                  S.of(context).nowLoadingTheVideo,
                                  style: _getErrorContainerTextStyle(),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
          ),
          if (!widget.isEmpty) ..._getPageElements(),
        ],
      ),
    );
  }
}
