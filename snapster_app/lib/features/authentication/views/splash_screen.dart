import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Splashscreen extends ConsumerWidget {
  static const String routeName = 'splash';
  static const String routeURL = '/splash';

  const Splashscreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
