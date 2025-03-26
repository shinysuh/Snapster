import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/widgets/video_config/video_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/video/view_models/playback_config_view_model.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _cancelLogOut(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _logOut(BuildContext context, WidgetRef ref) {
    ref.read(authRepository).signOut(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RegulatedMaxWidth(
      child: Localizations.override(
        context: context,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('settings'),
          ),
          body: ListView(
            children: [
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).muted,
                onChanged: (value) =>
                    ref.read(playbackConfigProvider.notifier).setMuted(value),
                title: const Text('Mute videos'),
                subtitle: const Text(
                  'Videos will be muted by default',
                  style: TextStyle(fontSize: Sizes.size12),
                ),
                activeColor: Theme.of(context).primaryColor,
              ),
              SwitchListTile.adaptive(
                value: ref.watch(playbackConfigProvider).autoplay,
                onChanged: (value) => ref
                    .read(playbackConfigProvider.notifier)
                    .setAutoplay(value),
                title: const Text('Autoplay videos'),
                activeColor: Theme.of(context).primaryColor,
              ),
              ValueListenableBuilder(
                valueListenable: screenModeConfig,
                builder: (context, value, child) => SwitchListTile.adaptive(
                  // ValueNotifier
                  value: value == ThemeMode.dark,
                  onChanged: (value) => screenModeConfig.value =
                      screenModeConfig.value == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light,
                  title: const Text('Dark Mode'),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
              ListTile(
                title: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () => showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text('Please confirm'),
                    actions: [
                      CupertinoDialogAction(
                        onPressed: () => _cancelLogOut(context),
                        child: const Text("No"),
                      ),
                      CupertinoDialogAction(
                        onPressed: () => _logOut(context, ref),
                        isDestructiveAction: true,
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                ),
              ),
              const AboutListTile(
                applicationVersion: 'version 1.0',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
