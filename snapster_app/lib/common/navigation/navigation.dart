import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 전역 내비게이터 키
final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>((_) {
  return GlobalKey<NavigatorState>();
});
