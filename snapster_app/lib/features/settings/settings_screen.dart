import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:snapster_app/common/widgets/video_config/video_config.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/authentication/providers/http_auth_provider.dart';
import 'package:snapster_app/features/video_old/view_models/playback_config_view_model.dart';
import 'package:snapster_app/utils/widgets/regulated_max_width.dart';

// ConsumerWidget => Riverpod StatelessWidget
// ConsumerStatefulWidget => Riverpod StatefulWidget
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  // bool _notifications = true;
  void _cancelLogOut(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _logOut(BuildContext context, WidgetRef ref) {
    ref.read(authRepositoryProvider).clearToken(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RegulatedMaxWidth(
      // Localizations.override - locale => 언어 설정 강제 기능
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     CupertinoSwitch(
              //       value: _notifications,
              //       onChanged: _onChangeNotifications,
              //       activeColor: const Color(0xff75B1DF),
              //     ),
              //     Switch(
              //       value: _notifications,
              //       onChanged: _onChangeNotifications,
              //       activeColor: Colors.deepPurple,
              //       activeThumbImage: const AssetImage('assets/images/1.jpeg'),
              //     ),
              //     // Switch.adaptive 형태 => iOS (CupertinoSwitch) / 다른 플랫폼 (기본 switch)
              //     Switch.adaptive(
              //       value: _notifications,
              //       onChanged: _onChangeNotifications,
              //       activeColor: Colors.red,
              //       activeThumbImage: const AssetImage('assets/images/1.jpeg'),
              //     ),
              //     Checkbox(
              //       value: _notifications,
              //       onChanged: _onChangeNotifications,
              //       checkColor: Colors.white,
              //       activeColor: const Color(0xffE694B0),
              //     ),
              //   ],
              // ),
              // CheckboxListTile(
              //   value: _notifications,
              //   onChanged: _onChangeNotifications,
              //   title: const Text('Enable Notifications'),
              //   checkColor: Colors.white,
              //   activeColor: const Color(0xffFA8857),
              // ),
              // SwitchListTile(
              //   value: _notifications,
              //   onChanged: _onChangeNotifications,
              //   title: const Text('Enable Notifications'),
              //   activeColor: const Color(0xff267428),
              //   activeThumbImage: const AssetImage('assets/images/1.jpeg'),
              // ),
              // // SwitchListTile.adaptive => 마찬가지로 플랫폼 별 UI 형태 다름

              SwitchListTile.adaptive(
                  value: ref.watch(playbackConfigProvider).muted,
                  // value: context.watch<PlaybackConfigViewModel>().muted,
                  onChanged: (value) =>
                      ref.read(playbackConfigProvider.notifier).setMuted(value),
                  // onChanged: (value) => context.read<PlaybackConfigViewModel>().setMuted(value),
                  title: const Text('Mute videos'),
                  activeColor: Theme.of(context).primaryColor,
                  subtitle: const Text(
                    'Videos will be muted by default',
                    style: TextStyle(fontSize: Sizes.size12),
                  )),
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
              // SwitchListTile.adaptive(
              //   value: false,
              //   onChanged: (value) {},
              //   title: const Text('Enable Notifications'),
              //   activeColor: Theme.of(context).primaryColor,
              //   activeThumbImage: const AssetImage('assets/images/1.jpeg'),
              // ),
              // CheckboxListTile.adaptive(
              //   value: false,
              //   onChanged: (value) {},
              //   title: const Text('Marketing emails'),
              //   subtitle: const Text(
              //     'Marketing emails from Snapster will be sent',
              //     style: TextStyle(fontSize: Sizes.size12),
              //   ),
              //   checkColor: Colors.white,
              //   activeColor: const Color(0xff52ac0b),
              // ),
              // ListTile(
              //   onTap: () async {
              //     final date = await showDatePicker(
              //       context: context,
              //       initialDate: DateTime.now(),
              //       firstDate: DateTime(1990),
              //       lastDate: DateTime(2030, DateTime.december, 30),
              //     );
              //     if (kDebugMode) print(date);
              //
              //     // if (!mounted) return;
              //     final time = await showTimePicker(
              //       context: context,
              //       initialTime: TimeOfDay.now(),
              //     );
              //     if (kDebugMode) print(time);
              //     final booking = await showDateRangePicker(
              //       context: context,
              //       firstDate: DateTime(1990),
              //       lastDate: DateTime(2030, DateTime.december, 30),
              //       builder: (context, child) {
              //         return Theme(
              //           data: ThemeData(
              //             appBarTheme: const AppBarTheme(
              //               foregroundColor: Colors.white,
              //               backgroundColor: Colors.black,
              //             ),
              //           ),
              //           child: child!,
              //         );
              //       },
              //     );
              //     if (kDebugMode) print(booking);
              //   },
              //   title: const Text('When is your birthday?'),
              // ),
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
              const AboutListTile(
                // AboutListTile : ListTile -> onTap -> showAboutDialog() 자동 적용된 것
                applicationVersion: 'version 2.0',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
