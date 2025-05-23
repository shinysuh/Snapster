import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/models/video_player_state_model.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/features/video/view_models/video_player_view_model.dart';
import 'package:snapster_app/features/video_old/view_models/playback_config_view_model.dart';
import 'package:snapster_app/features/video_old/views/widgets/video_caption.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/profile_network_img.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoStreamingPlayer extends ConsumerStatefulWidget {
  final VideoPostModel video;
  final int pageIndex;
  final bool isEmpty; // 앱에 영상이 하나도 없을 경우 에러 방지용
  final VoidCallback onVideoFinished; // 더 이상 로드할 영상이 없을 경우

  const VideoStreamingPlayer({
    super.key,
    required this.isEmpty,
    required this.pageIndex,
    required this.video,
    required this.onVideoFinished,
  });

  @override
  ConsumerState<VideoStreamingPlayer> createState() =>
      _VideoStreamingPlayerState();
}

class _VideoStreamingPlayerState extends ConsumerState<VideoStreamingPlayer>
    with SingleTickerProviderStateMixin {
  ChewieController? _chewieController;
  late final AnimationController _animationController;
  late final String _streamingUrl;
  bool _autoplay = false;

  final _animationDuration = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _streamingUrl = widget.video.streamingUrl;

    debugPrint('@@@@@@@@ Streaming URL: ${widget.video.streamingUrl}');

    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 2.0,
      value: 2.0,
      duration: _animationDuration,
    );

    _autoplay = ref.watch(playbackConfigProvider).autoplay;
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    final isVisible = info.visibleFraction == 1.0;
    final videoPlayer = ref.read(videoPlayerProvider(_streamingUrl).notifier);
    final videoState = ref.read(videoPlayerProvider(_streamingUrl));

    if (!videoState.isInitialized) return;

    final isPausedVideoPopped = isVisible && !videoState.isPlaying;
    final isPlayingVideoPassed = !isVisible && videoState.isPlaying;

    if (isPausedVideoPopped || isPlayingVideoPassed) {
      videoPlayer.togglePlay();
    }
  }

  Text _getNotificationText(String errText) {
    return Text(
      errText,
      style: const TextStyle(
        fontSize: Sizes.size20,
        color: Colors.white,
        fontWeight: FontWeight.bold,
        height: 1.8,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildNotificationWidget(String notification) {
    return Container(
      color: Colors.black,
      child: Center(
        child: _getNotificationText(notification),
      ),
    );
  }

  Widget _buildThumbnailOrLoader() {
    return Image.network(
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
              _getNotificationText(S.of(context).nowLoadingTheVideo),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(VideoPlayerState state) {
    final controller = state.controller;
    if (controller == null || !state.isInitialized) {
      return _buildNotificationWidget('video player 로딩 실패');
    }

    _chewieController ??= ChewieController(
        videoPlayerController: controller,
        autoPlay: _autoplay,
        looping: true,
        showControls: false,
        aspectRatio: controller.value.aspectRatio);

    controller.addListener(() {
      if (controller.value.position >= controller.value.duration &&
          !controller.value.isPlaying) {
        widget.onVideoFinished();
      }
    });

    return Chewie(controller: _chewieController!);
  }

  List<Widget> _getPageElements(
    BuildContext context,
    VideoPlayerViewModel videoPlayer,
    VideoPlayerState state,
  ) {
    return [
      Positioned.fill(
        child: GestureDetector(
          onTap: videoPlayer.togglePlay,
        ),
      ),
      _getVideoPlayIcon(state.isPlaying),
      _getUserAndVideoCaption(widget.video),
      Positioned(
        bottom: 25,
        right: 15,
        child: Column(
          children: [
            _getMutedIcon(videoPlayer, state.isMuted),
            Gaps.v24,
            _getUploadUserProfile(widget.video.userProfileImageUrl),
            // Gaps.v12,
            // GestureDetector(
            //   onTap: _onTapLike,
            //   child: VideoButton(
            //     icon: FontAwesomeIcons.solidHeart,
            //     iconColor: _isLiked ? Colors.red : Colors.white,
            //     text: S.of(context).likeCount(_likeCount),
            //   ),
            // ),
            // Gaps.v24,
            // GestureDetector(
            //   onTap: () => _onTapComments(context),
            //   child: VideoButton(
            //     icon: FontAwesomeIcons.solidCommentDots,
            //     iconColor: Colors.white,
            //     text: S.of(context).commentCount(_commentCount),
            //   ),
            // ),
            // Gaps.v24,
            // VideoButton(
            //   icon: FontAwesomeIcons.share,
            //   iconColor: Colors.white,
            //   text: S.of(context).share,
            // ),
            Gaps.v20,
          ],
        ),
      )
    ];
  }

  Widget _getVideoPlayIcon(bool isPlaying) {
    return Positioned.fill(
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
            child: _autoplay
                ? AnimatedOpacity(
                    duration: _animationDuration,
                    opacity: isPlaying ? 0 : 1,
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
    );
  }

  Widget _getUserAndVideoCaption(VideoPostModel video) {
    return Positioned(
      bottom: 25,
      left: 15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '@${video.userDisplayName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.v18,
          if (video.description.isNotEmpty)
            VideoCaption(
              description: video.description,
              tags: video.tags,
            ),
        ],
      ),
    );
  }

  Widget _getMutedIcon(VideoPlayerViewModel videoPlayer, bool isMuted) {
    return GestureDetector(
      onTap: videoPlayer.toggleMute,
      child: FaIcon(
        isMuted ? FontAwesomeIcons.volumeXmark : FontAwesomeIcons.volumeHigh,
        color: Colors.white,
        size: Sizes.size24,
      ),
    );
  }

  Widget _getUploadUserProfile(String profileImageUrl) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      foregroundImage: profileImageUrl.isNotEmpty
          ? getProfileImgByUserProfileImageUrl(
              profileImageUrl,
              false,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEmpty) {
      return _buildNotificationWidget(S.of(context).noVideosToShow);
    }

    final videoState = ref.watch(videoPlayerProvider(_streamingUrl));
    final videoPlayer = ref.watch(videoPlayerProvider(_streamingUrl).notifier);

    if (videoState.isPlaying != _autoplay) {
      videoPlayer.togglePlay();
    }

    return VisibilityDetector(
      key: Key('video-player-${widget.pageIndex}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: videoState.hasError
                ? _buildNotificationWidget('영상 로딩 실패')
                : !videoState.isInitialized
                    ? _buildThumbnailOrLoader()
                    : _buildVideoPlayer(videoState),
          ),
          if (!widget.isEmpty)
            ..._getPageElements(context, videoPlayer, videoState),
        ],
      ),
    );
  }
}
