import 'package:flutter/cupertino.dart';

/* ChangeNotifier 학습용 클래스 */
class VideoConfig extends ChangeNotifier {
  // 데이터 Listening 하는 부분에서 AnimatedBuilder 사용 OR 이벤트 리스너 추가
  // 데이터 변경 시, AnimatedBuilder 부분만 rebuild 됨 -> 성능 향상
  bool autoMute = false;

  void toggleMuted() {
    autoMute = !autoMute;
    notifyListeners();    // 데이터를 리스닝하는 파트에 notify
  }
}

final videoConfig = VideoConfig();

// /* InheritedWidget 학습용 클래스 */
// class VideoConfigData extends InheritedWidget {
//   final bool autoMute;
//   final void Function() toggleMuted;
//
//   const VideoConfigData({
//     super.key,
//     required super.child,
//     required this.autoMute,
//     required this.toggleMuted,
//   });
//
//   static VideoConfigData of(BuildContext context) {
//     // dependOnInheritedWidgetOfExactType<클래스명> => context가 지정 클래스 타입의 inheritedWidget을 가져오게 함
//     return context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;
//   }
//
//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return true;
//   }
// }
//
// class VideoConfig extends StatefulWidget {
//   final Widget child;
//
//   const VideoConfig({
//     super.key,
//     required this.child,
//   });
//
//   @override
//   State<VideoConfig> createState() => _VideoConfigState();
// }
//
// class _VideoConfigState extends State<VideoConfig> {
//   // InheritedWidget 의 데이터를 업데이트하는 메커니즘은 없음
//   // StatefulWidget 와 연계해 이용
//   bool autoMute = false;
//
//   void toggleMuted() {
//     setState(() {
//       autoMute = !autoMute;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return VideoConfigData(
//       autoMute: autoMute,
//       toggleMuted: toggleMuted,
//       child: widget.child,
//     );
//   }
// }
