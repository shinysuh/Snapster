import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/models/video_player_state_model.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/features/video/view_models/video_player_view_model.dart';
import 'package:snapster_app/features/video/views/widgets/video_page_elements.dart';
import 'package:snapster_app/features/video_old/view_models/playback_config_view_model.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:video_player/video_player.dart';
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
  late final String _streamingUrl;
  bool _autoplay = false;

  @override
  void initState() {
    super.initState();
    _streamingUrl = widget.video.streamingUrl;

    debugPrint('@@@@@@@@ Streaming URL: ${widget.video.streamingUrl}');

    _autoplay = ref.watch(playbackConfigProvider).autoplay;
  }

  @override
  void dispose() {
    _chewieController?.dispose();
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

  Widget _buildVideoPlayer(VideoPlayerState state) {
    final controller = state.controller;
    if (controller == null || !state.isInitialized) {
      return _buildNotificationWidget('@@@@@@@@ video player 로딩 실패');
    }

    if (controller.value.hasError) {
      debugPrint('@@@@@@@@ Video error: ${controller.value.errorDescription}');
    }

    _initChewieController(controller);

    controller.addListener(() {
      if (controller.value.position >= controller.value.duration &&
          !controller.value.isPlaying) {
        widget.onVideoFinished();
      }
    });

    // return Chewie(controller: _chewieController!);
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }

  void _initChewieController(VideoPlayerController controller) {
    if (_chewieController != null &&
        _chewieController!.videoPlayerController != controller) {
      _chewieController!.dispose();
      _chewieController = null;
    }

    _chewieController ??= ChewieController(
      videoPlayerController: controller,
      autoPlay: _autoplay,
      looping: true,
      showControls: false,
      aspectRatio: controller.value.aspectRatio,
    );
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
            VideoPageElements(
              video: widget.video,
              state: videoState,
              videoPlayer: videoPlayer,
            ),
        ],
      ),
    );
  }
}
