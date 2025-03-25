import 'package:flutter/material.dart';

// not using
class VideoConfig extends ChangeNotifier {
  bool isMuted = false;
  bool isAutoplay = false;

  void muteVideos() {
    isMuted = true;
    notifyListeners();
  }

  void toggleIsMuted() {
    isMuted = !isMuted;
    notifyListeners();
  }

  void toggleAutoPlay() {
    isAutoplay = !isAutoplay;
    notifyListeners();
  }
}

final videoConfig = ValueNotifier(false);
final screenModeConfig = ValueNotifier(ThemeMode.light);
