import 'package:better_player/better_player.dart';

class HlsPlayerState {
  final BetterPlayerController? controller;
  final bool isInitialized;
  final bool isPlaying;
  final bool isMuted;
  final bool hasError;

  HlsPlayerState({
    required this.controller,
    required this.isInitialized,
    required this.isPlaying,
    required this.isMuted,
    required this.hasError,
  });

  HlsPlayerState copyWith({
    BetterPlayerController? controller,
    bool? isInitialized,
    bool? isPlaying,
    bool? isMuted,
    bool? hasError,
  }) {
    return HlsPlayerState(
      controller: controller ?? this.controller,
      isInitialized: isInitialized ?? this.isInitialized,
      isPlaying: isPlaying ?? this.isPlaying,
      isMuted: isMuted ?? this.isMuted,
      hasError: hasError ?? this.hasError,
    );
  }

  factory HlsPlayerState.initial() {
    return HlsPlayerState(
      controller: null,
      isInitialized: false,
      isPlaying: false,
      isMuted: false,
      hasError: false,
    );
  }
}
