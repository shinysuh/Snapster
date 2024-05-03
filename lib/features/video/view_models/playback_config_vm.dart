import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/video/models/playback_config_model.dart';
import 'package:tiktok_clone/features/video/repositories/video_playback_config_repository.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  final VideoPlaybackConfigRepository _repository;

  late final PlaybackConfigModel _model = PlaybackConfigModel(
    muted: _repository.isMuted(),
    autoplay: _repository.isAutoplay(),
  );

  PlaybackConfigViewModel(this._repository);

  bool get muted => _model.muted;

  bool get autoplay => _model.autoplay;

  void setMuted(bool value) {
    _repository.setMuted(value);
    _model.muted = value;
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoPlay(value);
    _model.autoplay = value;
    notifyListeners();
  }
}
