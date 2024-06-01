import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/video_config/video_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/repositories/authentication_repository.dart';
import 'package:tiktok_clone/features/video/view_models/playback_config_view_model.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  // bool _notifications = true;
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
        // locale: const Locale('fr'),
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
              ValueListenableBuilder(
                valueListenable: videoConfig,
                builder: (context, value, child) => SwitchListTile.adaptive(
                  value: value,
                  onChanged: (value) => videoConfig.value = !videoConfig.value,
                  title: const Text('Auto mute videos(ValueListenableBuilder)'),
                  subtitle: const Text(
                    'Videos will be muted by default\n(currently not connected)',
                    style: TextStyle(fontSize: Sizes.size12),
                  ),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
              AnimatedBuilder(
                animation: videoConfig,
                builder: (context, child) => SwitchListTile.adaptive(
                  value: videoConfig.value,
                  onChanged: (value) => videoConfig.value = !videoConfig.value,
                  title: const Text('Auto mute videos(AnimatedBuilder)'),
                  subtitle: const Text(
                    'Videos will be muted by default\n(currently not connected)',
                    style: TextStyle(fontSize: Sizes.size12),
                  ),
                  activeColor: Theme.of(context).primaryColor,
                ),
              ),
              // ),
              SwitchListTile.adaptive(
                value: false,
                onChanged: (value) {},
                title: const Text('Enable Notifications'),
                activeColor: Theme.of(context).primaryColor,
              ),
              CheckboxListTile.adaptive(
                value: false,
                onChanged: (value) {},
                title: const Text('Marketing emails'),
                subtitle: const Text(
                  'Marketing emails from TikTok will be sent',
                  style: TextStyle(fontSize: Sizes.size12),
                ),
                checkColor: Colors.white,
                activeColor: const Color(0xff52ac0b),
              ),
              ListTile(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime(2030, DateTime.december, 30),
                  );
                  if (kDebugMode) print(date);

                  // if (!context.mounted) return;
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (kDebugMode) print(time);
                  final booking = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(1990),
                    lastDate: DateTime(2030, DateTime.december, 30),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData(
                          appBarTheme: const AppBarTheme(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (kDebugMode) print(booking);
                },
                title: const Text('When is your birthday?'),
              ),
              ListTile(
                title: const Text(
                  'Log Out (iOS)',
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
              ListTile(
                title: const Text(
                  'Log Out (Android)',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: const FaIcon(FontAwesomeIcons.faceSadTear),
                    title: const Text(
                      'Are you sure?',
                      textAlign: TextAlign.left,
                    ),
                    content: const Text('Please confirm'),
                    actions: [
                      TextButton(
                        onPressed: () => _cancelLogOut(context),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => _logOut(context, ref),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Log Out (iOS / Bottom Dialog)',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () => showCupertinoModalPopup(
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
              ListTile(
                title: const Text(
                  'Log Out (iOS / Bottom Action Sheet)',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => CupertinoActionSheet(
                    title: const Text(
                      'Are you sure?',
                    ),
                    message: const Text('Please confirm'),
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () => _cancelLogOut(context),
                        isDefaultAction: true,
                        child: const Text('No'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: () => _logOut(context, ref),
                        isDestructiveAction: true,
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                ),
              ),
              const AboutListTile(
                applicationVersion: 'version 2.0',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
