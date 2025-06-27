import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/widgets/navigation/router.dart';
import 'package:snapster_app/common/widgets/navigation/views/main_navigation_screen.dart';
import 'package:snapster_app/features/authentication/renewal/view_models/auth_view_model.dart';
import 'package:snapster_app/features/authentication/views/login/login_screen.dart';

class DeepLinkHandler {
  final WidgetRef ref;
  late final AppLinks _appLinks;
  late final StreamSubscription _sub;

  DeepLinkHandler(this.ref) {
    _appLinks = AppLinks();
  }

  void dispose() {
    _sub.cancel();
  }

  void startListening() {
    _sub = _appLinks.uriLinkStream.listen((uri) async {
      await _handleDeepLink(uri);
    }, onError: (e) {
      debugPrint('❌ uriLinkStream error: $e');
    });

    // _sub = uriLinkStream.listen((uri) async {
    //   if (uri == null) return;
    //   await _handleDeepLink(uri);
    // }, onError: (e) {
    //   debugPrint('❌ uriLinkStream error: $e');
    // });
  }

  Future<void> _handleDeepLink(Uri uri) async {
    final repo = ref.read(authProvider.notifier);
    final success = await repo.loginWithDeepLink(uri, ref);
    // 화면 이동
    final location =
        success ? MainNavigationScreen.homeRouteURL : LoginScreen.routeURL;
    ref.read(routerProvider).go(location);
  }
}
