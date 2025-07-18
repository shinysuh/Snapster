import 'dart:async';

import 'package:flutter/material.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _sub;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _sub = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
