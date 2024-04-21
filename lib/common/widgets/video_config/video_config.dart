import 'package:flutter/cupertino.dart';

/* InheritedWidget 학습용 클래스 */
class VideoConfig extends InheritedWidget {
  const VideoConfig({
    super.key,
    required super.child,
  });

  static VideoConfig of(BuildContext context) {
    // dependOnInheritedWidgetOfExactType<클래스명> => context가 지정 클래스 타입의 inheritedWidget을 가져오게 함
    return context.dependOnInheritedWidgetOfExactType<VideoConfig>()!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}
