import 'package:video_player/video_player.dart';

class VideoPlayerState {
  final VideoPlayerController? controller;
  final bool isInitialized;
  final bool isPlaying;
  final bool isMuted;
  final bool hasError;

  VideoPlayerState({
    required this.controller,
    required this.isInitialized,
    required this.isPlaying,
    required this.isMuted,
    required this.hasError,
  });

  VideoPlayerState copyWith({
    VideoPlayerController? controller,
    bool? isInitialized,
    bool? isPlaying,
    bool? isMuted,
    bool? hasError,
  }) {
    return VideoPlayerState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      hasError: hasError ?? this.hasError,
    );
  }

  factory VideoPlayerState.initial() {
    return VideoPlayerState(
      controller: null,
      isInitialized: false,
      isPlaying: false,
      isMuted: false,
      hasError: false,
    );
  }
}
