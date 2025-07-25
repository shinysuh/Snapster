import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/widgets/navigation/views/main_navigation_screen.dart';
import 'package:snapster_app/features/authentication/renewal/view_models/auth_view_model.dart';
import 'package:snapster_app/features/authentication/views/login/login_screen.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class Splashscreen extends ConsumerStatefulWidget {
  static const String routeName = 'splash';
  static const String routeURL = '/splash';

  const Splashscreen({super.key});

  @override
  ConsumerState<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends ConsumerState<Splashscreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    initApp();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> initApp() async {
    await Future.delayed(const Duration(milliseconds: 100)); // ⏳ 렌더링 시간 확보

    final user = ref.watch(authProvider);

    if (!mounted) return;
    final route =
        user != null ? MainNavigationScreen.homeRouteURL : LoginScreen.routeURL;

    goRouteReplacementRoute(
      context: context,
      routeURL: route,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
