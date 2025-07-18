import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/features/authentication/renewal/view_models/auth_view_model.dart';
import 'package:snapster_app/features/chat/providers/chat_providers.dart';
import 'package:snapster_app/features/user/view_models/http_user_profile_view_model.dart';

class AppLifecycleHandler with WidgetsBindingObserver {
  final WidgetRef ref;
  final BuildContext context;

  AppLifecycleHandler(this.ref, this.context) {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final stompRepository = ref.read(stompRepositoryProvider);
    final onlineStatus = ref.read(httpUserProfileProvider.notifier);

    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      stompRepository.disconnect();
      onlineStatus.setUserOffline(context);
    }

    if (state == AppLifecycleState.resumed) {
      ref.read(authProvider.notifier).initialize();
      onlineStatus.setUserOnline(context);
    }
  }
}
