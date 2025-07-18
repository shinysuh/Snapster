import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/models/video_post_model.dart';
import 'package:snapster_app/features/video/views/widgets/video_page_elements.dart';
import 'package:snapster_app/features/video_old/view_models/playback_config_view_model.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoStreamingPlayer extends ConsumerStatefulWidget {
  final bool isEmpty;
  final int pageIndex;
  final VideoPostModel video;

  const VideoStreamingPlayer({
    super.key,
    required this.isEmpty,
    required this.pageIndex,
    required this.video,
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

  void _togglePlay(bool isPlaying) {
    if (isPlaying) {
      _player.play();
    } else {
      _player.pause();
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    _togglePlay(info.visibleFraction == 1);
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
      bottom: MediaQuery.of(context).padding.bottom,
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
    final isMuted = kIsWeb ? true : ref.watch(playbackConfigProvider).muted;
    final autoPlay = ref.watch(playbackConfigProvider).autoplay;

    _player.setVolume(isMuted ? 0 : 100);
    _togglePlay(autoPlay);

    return VisibilityDetector(
      key: Key('${widget.pageIndex}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            bottom: MediaQuery.of(context).padding.bottom,
            child: widget.isEmpty
                ? Container(
                    color: Colors.black,
                    child: Center(
                      child: Text(
                        S.of(context).noVideosToShow,
                        // "No more videos to display. \nYou've seen all.",
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
                    ? IgnorePointer(
                        ignoring: true,
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Video(controller: _controller),
                        ),
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
          if (!widget.isEmpty)
            VideoPageElements(
              video: widget.video,
              player: _player,
              isMuted: isMuted,
            ),
        ],
      ),
    );
  }
}
