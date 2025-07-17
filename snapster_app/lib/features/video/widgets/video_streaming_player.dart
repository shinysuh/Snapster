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

class VideoStreamingPlayer extends ConsumerStatefulWidget {
  final bool isEmpty;
  final int pageIndex;
  final VideoPostModel video;
  final VoidCallback onVideoFinished;

  const VideoStreamingPlayer({
    super.key,
    required this.isEmpty,
    required this.pageIndex,
    required this.video,
    required this.onVideoFinished,
  });

  @override
  ConsumerState<VideoStreamingPlayer> createState() =>
      _MediaKitStreamingPlayerState();
}

class _MediaKitStreamingPlayerState
    extends ConsumerState<VideoStreamingPlayer> {
  late final Player _player;
  late final VideoController _controller;

  late final String _streamingUrl;
  bool _isInitialized = false;

  late final String _videoId;
  bool _isPaused = false;
  bool _isLiked = false;
  int _likeCount = 0;
  int _commentCount = 0;

  late bool _isMuted = kIsWeb ? true : ref.watch(playbackConfigProvider).muted;
  late bool _autoPlay = ref.watch(playbackConfigProvider).autoplay;

  @override
  void initState() {
    super.initState();
    _streamingUrl = widget.video.streamingUrl;

    _player = Player();
    _controller = VideoController(_player);

    _initializePlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    try {
      await _player.open(Media(_streamingUrl));
      await _player.setPlaylistMode(PlaylistMode.loop);
      setState(() {
        _isInitialized = true;
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
    if (!_autoPlay) _autoPlay = true;

    if (_player.state.playing) {
      _player.pause();
    } else {
      _player.play();
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

  Widget _getProgressBar() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: StreamBuilder<Duration>(
        stream: _player.stream.position,
        builder: (context, snapshot) {
          final position = snapshot.data ?? Duration.zero;
          final duration = _player.state.duration;

          final progress = (duration.inMilliseconds > 0)
              ? position.inMilliseconds / duration.inMilliseconds
              : 0.0;

          return LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: Colors.transparent,
            color: Colors.redAccent,
            minHeight: 3,
          );
        },
      ),
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
          // ✅ 영상 진행 바 추가
          if (_isInitialized) _getProgressBar(),
          // 영상 위 UI 요소들
          if (!widget.isEmpty) ..._getPageElements(), // 필요하다면 이 함수 추가
        ],
      ),
    );
  }
}
