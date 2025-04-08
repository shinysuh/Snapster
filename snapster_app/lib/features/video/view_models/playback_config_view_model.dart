import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/video/models/playback_config_model.dart';
import 'package:snapster_app/features/video/repositories/playback_config_repository.dart';

/* Riverpod */
class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    _repository.setMuted(value);
    // state 값은 immutable => 새로 state 생성 필요 (state.muted = value 불가)
    state = PlaybackConfigModel(
      muted: value,
      autoplay: state.autoplay,
    );
  }

  void setAutoplay(bool value) {
    _repository.setAutoPlay(value);
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: value,
    );
  }

  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
    );
  }
}

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () =>
      // main.dart 에서 flutter await 이후 sharedPreferences 를 받기 위해 이렇게 처리
      // main.dart 에서 override 함
      throw UnimplementedError(),
  // PlaybackConfigViewModel(),
);

/* Provider */
// class PlaybackConfigViewModel extends ChangeNotifier {
//   final PlaybackConfigRepository _repository;
//
//   late final PlaybackConfigModel _model = PlaybackConfigModel(
//     muted: _repository.isMuted(),
//     autoplay: _repository.isAutoplay(),
//   );
//
//   PlaybackConfigViewModel(this._repository);
//
//   bool get muted => _model.muted;
//
//   bool get autoplay => _model.autoplay;
//
//   void setMuted(bool value) {
//     _repository.setMuted(value);
//     _model.muted = value;
//     notifyListeners();
//   }
//
//   void setAutoplay(bool value) {
//     _repository.setAutoPlay(value);
//     _model.autoplay = value;
//     notifyListeners();
//   }
// }
