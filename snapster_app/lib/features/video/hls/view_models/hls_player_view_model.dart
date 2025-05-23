import 'package:better_player/better_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/video/hls/models/hls_player_state_model.dart';

class HlsPlayerViewModel extends StateNotifier<HlsPlayerState>
    with WidgetsBindingObserver {
  final String streamingUrl;

  HlsPlayerViewModel(this.streamingUrl) : super(HlsPlayerState.initial()) {
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
      // 1) 스트리밍 소스 정의
      final dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        streamingUrl,
        notificationConfiguration: const BetterPlayerNotificationConfiguration(
          showNotification: false,
        ),
      );

      // 2) 컨트롤러 초기화
      final controller = BetterPlayerController(
        const BetterPlayerConfiguration(
          autoPlay: true,
          looping: true,
          fit: BoxFit.cover,
          handleLifecycle: true,
          autoDetectFullscreenDeviceOrientation: true,
          controlsConfiguration: BetterPlayerControlsConfiguration(
            showControls: false,
          ),
        ),
        betterPlayerDataSource: dataSource,
      );

      // 3) 이벤트 리스너로 isPlaying 동기화
      controller.addEventsListener((event) {
        if (event.betterPlayerEventType == BetterPlayerEventType.play) {
          state = state.copyWith(isPlaying: true);
        } else if (event.betterPlayerEventType == BetterPlayerEventType.pause) {
          state = state.copyWith(isPlaying: false);
        } else if (event.betterPlayerEventType ==
            BetterPlayerEventType.finished) {
          // 재생 완료 감지 (onVideoFinished 호출은 뷰에서)
          state = state.copyWith(isPlaying: false);
        }
      });

      // 4) 초기 상태 업데이트
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

  void _stopPlay(BetterPlayerController controller) {
    controller.pause();
    state = state.copyWith(isPlaying: false);
  }

  void _startPlay(BetterPlayerController controller) {
    controller.play();
    state = state.copyWith(isPlaying: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = this.state.controller;
    if (controller == null || !this.state.isInitialized) return;

    if (state == AppLifecycleState.paused) {
      // 앱 백그라운드 시 영상 일시 정지
      if (this.state.isPlaying) {
        _stopPlay(controller);
      }
    } else if (state == AppLifecycleState.resumed) {
      // 앱 foreground 시 자동 재생 (원할 경우)
      _startPlay(controller);
    }
  }
}

final hlsPlayerProvider =
    StateNotifierProvider.family<HlsPlayerViewModel, HlsPlayerState, String>(
        (ref, streamingUrl) {
  final viewModel = HlsPlayerViewModel(streamingUrl);
  ref.onDispose(() => viewModel.dispose());
  return viewModel;
});
