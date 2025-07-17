import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/features/video_old/view_models/playback_config_view_model.dart';
import 'package:snapster_app/features/video_old/views/widgets/video_button.dart';
import 'package:snapster_app/features/video_old/views/widgets/video_caption.dart';
import 'package:snapster_app/features/video_old/views/widgets/video_comments.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/profile_network_img.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MediaKitStreamingPlayer extends ConsumerStatefulWidget {
  final bool isEmpty;
  final int pageIndex;
  final VideoPostModel video;
  final VoidCallback onVideoFinished;

  const MediaKitStreamingPlayer({
    super.key,
    required this.isEmpty,
    required this.pageIndex,
    required this.video,
    required this.onVideoFinished,
  });

  @override
  ConsumerState<MediaKitStreamingPlayer> createState() =>
      _MediaKitStreamingPlayerState();
}

class _MediaKitStreamingPlayerState
    extends ConsumerState<MediaKitStreamingPlayer>
    with SingleTickerProviderStateMixin {
  late final Player _player;
  late final VideoController _controller;

  late final AnimationController _animationController;
  final _animationDuration = const Duration(milliseconds: 200);

  late final String _streamingUrl;
  bool _isInitialized = false;

  late final String _videoId;
  bool _isPaused = false;
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;

  late bool _isMuted = kIsWeb ? true : ref.watch(playbackConfigProvider).muted;
  late bool _showPlayButton = ref.watch(playbackConfigProvider).autoplay;

  @override
  void initState() {
    super.initState();
    _streamingUrl = widget.video.streamingUrl;

    _player = Player();
    _controller = VideoController(_player);

    _initializePlayer();

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
    _player.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    try {
      await _player.open(Media(_streamingUrl));
      setState(() {
        _isInitialized = true;
      });

      _player.stream.completed.listen((_) {
        widget.onVideoFinished();
      });


      _player.stream.log.listen((event) {
        debugPrint('[player.log] $event'); // 로그 출력
      });

      _player.stream.error.listen((error) {
        debugPrint('[player.error] $error'); // 에러 발생시 출력
      });

    } catch (e) {
      debugPrint('HLS open error: $e');
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction == 1) {
      _player.play();
    } else {
      _player.pause();
    }
  }

  void _toggleMuted() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _togglePause() {
    if (!_showPlayButton) _showPlayButton = true;

    if (_player.state.playing) {
      _player.pause();
      _animationController.reverse();
    } else {
      _player.play();
      _animationController.forward();
    }

    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _onTapLike() {
    // ref
    //     .read(videoPostProvider(_videoId).notifier)
    //     .toggleLikeVideo(widget.videoData.thumbnailURL);

    // setState(() {
    //   !_isLiked ? _likeCount++ : _likeCount--; // db를 직접 찌르지 않음 -> 금전적 이유
    //   _isLiked = !_isLiked;
    // });
  }

  void _onChangeCommentCount(int commentCount) {
    // setState(() {
    //   _commentCount = commentCount;
    // });
  }

  void _onTapComments(BuildContext context) async {
    if (_player.state.playing) _togglePause();

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
              '@${widget.video.userDisplayName}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v18,
            if (widget.video.description.isNotEmpty)
              VideoCaption(
                description: widget.video.description,
                tags: widget.video.tags,
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
              foregroundImage: getProfileImgByUserProfileImageUrl(
                widget.video.userProfileImageUrl.isNotEmpty,
                widget.video.userProfileImageUrl,
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
                    ? AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Video(controller: _controller),
                      )
                    : Image.network(
                        widget.video.thumbnailUrl,
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
          if (!widget.isEmpty) ..._getPageElements(), // 필요하다면 이 함수 추가
        ],
      ),
    );
  }
}
