import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/hls/models/hls_player_state_model.dart';
import 'package:snapster_app/features/video/hls/view_models/hls_player_view_model.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/features/video_old/view_models/playback_config_view_model.dart';
import 'package:snapster_app/generated/l10n.dart';

class HlsStreamingPlayer extends ConsumerStatefulWidget {
  final bool isEmpty;
  final int pageIndex;
  final VideoPostModel video;
  final VoidCallback onVideoFinished;

  const HlsStreamingPlayer({
    super.key,
    required this.isEmpty,
    required this.pageIndex,
    required this.video,
    required this.onVideoFinished,
  });

  @override
  ConsumerState<HlsStreamingPlayer> createState() => _HlsStreamingPlayerState();
}

class _HlsStreamingPlayerState extends ConsumerState<HlsStreamingPlayer> {
  late final String _streamingUrl;
  bool _listenerAttached = false;

  late final _autoplay = ref.watch(playbackConfigProvider).autoplay;

  @override
  void initState() {
    super.initState();
    _streamingUrl = widget.video.streamingUrl;

    // autoplay 설정 변화에 따라 togglePlay 호출
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(hlsPlayerProvider(_streamingUrl));
      final notifier = ref.read(hlsPlayerProvider(_streamingUrl).notifier);

      if (state.isInitialized && state.isPlaying != _autoplay) {
        notifier.togglePlay();
      }
    });
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

  Widget _buildVideoPlayer(HlsPlayerState state) {
    final controller = state.controller;
    if (controller == null) {
      return _buildNotificationWidget('video player 로딩 실패');
    }
    return BetterPlayer(controller: controller);
  }

  void _attachFinishListener(BetterPlayerController controller) {
    if (_listenerAttached) return;
    _listenerAttached = true;

    controller.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
        widget.onVideoFinished();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEmpty) {
      return _buildNotificationWidget(S.of(context).noVideosToShow);
    }

    final videoState = ref.watch(hlsPlayerProvider(_streamingUrl));
    final videoPlayer = ref.watch(hlsPlayerProvider(_streamingUrl).notifier);

    final controller = videoState.controller;
    if (controller != null) {
      _attachFinishListener(controller);
    }

    return Stack(
      children: [
        Positioned.fill(
          child: videoState.hasError
              ? _buildNotificationWidget('영상 로딩 실패')
              : !videoState.isInitialized
                  ? _buildThumbnailOrLoader()
                  : _buildVideoPlayer(videoState),
        ),
        // if (!widget.isEmpty)
        //   VideoPageElements(
        //     video: widget.video,
        //     state: videoState,
        //     videoPlayer: videoPlayer,
        //   ),
      ],
    );
  }
}
