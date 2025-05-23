import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/video/models/video_player_state_model.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerViewModel extends StateNotifier<VideoPlayerState>
    with WidgetsBindingObserver {
  final String streamingUrl;

  VideoPlayerViewModel(this.streamingUrl) : super(VideoPlayerState.initial()) {
    WidgetsBinding.instance.addObserver(this);
    _initVideoPlayer();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    state.controller?.dispose();
    super.dispose();
  }

  Future<void> _initVideoPlayer() async {
    try {
      final controller =
          VideoPlayerController.networkUrl(Uri.parse(streamingUrl));
      await controller.initialize();
      // 영상 반복 재생
      controller.setLooping(true);
      // 음소거 기본값 설정
      controller.setVolume(state.isMuted ? 0 : 1);

      controller.addListener(() {
        // 상태 변경 갱신
        final playing = controller.value.isPlaying;
        if (playing != state.isPlaying) {
          state = state.copyWith(isPlaying: playing);
        }
      });

      state = state.copyWith(
        controller: controller,
        isInitialized: true,
        hasError: false,
      );
    } catch (e) {
      // 초기화 실패 시 에러 상태 갱신
      state = state.copyWith(hasError: true);
    }
  }

  void toggleMute() {
    final controller = state.controller;
    if (controller == null || !state.isInitialized) return;

    final muted = !state.isMuted;
    controller.setVolume(muted ? 0 : 1);
    state = state.copyWith(isMuted: muted);
  }

  void togglePlay() {
    final controller = state.controller;
    if (controller == null || !state.isInitialized) return;

    if (state.isPlaying) {
      _stopPlay(controller);
    } else {
      _startPlay(controller);
    }
  }

  void _stopPlay(VideoPlayerController controller) {
    controller.pause();
    state = state.copyWith(isPlaying: false);
  }

  void _startPlay(VideoPlayerController controller) {
    controller.play();
    state = state.copyWith(isPlaying: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    final controller = state.controller;
    if (controller == null || !state.isInitialized) return;

    if (appState == AppLifecycleState.paused) {
      // 앱 백그라운드 시 영상 일시 정지
      if (state.isPlaying) {
        _stopPlay(controller);
      } else if (appState == AppLifecycleState.resumed) {
        // 앱 foreground 시 자동 재생 (원할 경우)
        _startPlay(controller);
      }
    }
  }
}

final videoPlayerProvider = StateNotifierProvider.family<VideoPlayerViewModel,
    VideoPlayerState, String>((ref, videoUrl) {
  final viewModel = VideoPlayerViewModel(videoUrl);
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});
