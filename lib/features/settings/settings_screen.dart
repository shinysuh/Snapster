import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/video_config/video_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';
import 'package:tiktok_clone/utils/widgets/regulated_max_width.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _marketingEmails = true;

  void _onChangeNotifications(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  void _onChangeMarketingEmails(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _marketingEmails = newValue;
    });
  }

  void _cancelLogOut() {
    Navigator.of(context).pop();
  }

  void _logOut() {
    // TODO - 로그아웃 기능 여기 구현

    redirectToScreenAndRemovePreviousRoutes(
      context: context,
      targetScreen: const SignUpScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RegulatedMaxWidth(
      // Localizations.override - locale => 언어 설정 강제 기능
      child: Localizations.override(
        context: context,
        // locale: const Locale('fr'),
        child: Scaffold(
          appBar: AppBar(
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
                value: false,
                // value: context.watch<PlaybackConfigViewModel>().muted,
                onChanged: (value) {},
                // onChanged: (value) => context.read<PlaybackConfigViewModel>().setMuted(value),
                title: const Text('Mute videos'),
                activeColor: Theme.of(context).primaryColor,
                // activeThumbImage: const AssetImage('assets/images/1.jpeg'),
              ),
              SwitchListTile.adaptive(
                value: true,
                // value: context.watch<PlaybackConfigViewModel>().autoplay,
                onChanged: (value) {},
                // onChanged: (value) => context.read<PlaybackConfigViewModel>().setAutoplay(value),
                title: const Text('Autoplay videos'),
                activeColor: Theme.of(context).primaryColor,
                // activeThumbImage: const AssetImage('assets/images/1.jpeg'),
              ),

              // // provider
              // SwitchListTile.adaptive(
              //   // ValueNotifier
              //   value: context.watch<VideoConfig>().isMuted,
              //   onChanged: (value) =>
              //       context.read<VideoConfig>().toggleIsMuted(),
              //   // ChangeNotifier
              //   // value: videoConfig.autoMute,
              //   // onChanged: (value) => videoConfig.toggleMuted(),
              //   title: const Text('Auto mute videos(Provider)'),
              //   subtitle: const Text(
              //     'Videos will be muted by default\n(currently not connected)',
              //     style: TextStyle(fontSize: Sizes.size12),
              //   ),
              //   activeColor: Theme.of(context).primaryColor,
              //   // activeThumbImage: const AssetImage('assets/images/1.jpeg'),
              // ),
              ValueListenableBuilder(
                valueListenable: screenModeConfig,
                builder: (context, value, child) => SwitchListTile.adaptive(
                  // ValueNotifier
                  value: value == ThemeMode.dark,
                  onChanged: (value) => screenModeConfig.value =
                      screenModeConfig.value == ThemeMode.light
                          ? ThemeMode.dark
                          : ThemeMode.light,
                  // ChangeNotifier
                  // value: videoConfig.autoMute,
                  // onChanged: (value) => videoConfig.toggleMuted(),
                  title: const Text('Dark Mode'),
                  activeColor: Theme.of(context).primaryColor,
                  // activeThumbImage: const AssetImage('assets/images/1.jpeg'),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: videoConfig,
                builder: (context, value, child) => SwitchListTile.adaptive(
                  // ValueNotifier
                  value: value,
                  onChanged: (value) => videoConfig.value = !videoConfig.value,
                  // ChangeNotifier
                  // value: videoConfig.autoMute,
                  // onChanged: (value) => videoConfig.toggleMuted(),
                  title: const Text('Auto mute videos(ValueListenableBuilder)'),
                  subtitle: const Text(
                    'Videos will be muted by default\n(currently not connected)',
                    style: TextStyle(fontSize: Sizes.size12),
                  ),
                  activeColor: Theme.of(context).primaryColor,
                  // activeThumbImage: const AssetImage('assets/images/1.jpeg'),
                ),
              ),
              AnimatedBuilder(
                animation: videoConfig,
                builder: (context, child) => SwitchListTile.adaptive(
                  // ValueNotifier
                  value: videoConfig.value,
                  onChanged: (value) => videoConfig.value = !videoConfig.value,
                  // ChangeNotifier
                  // value: videoConfig.autoMute,
                  // onChanged: (value) => videoConfig.toggleMuted(),
                  title: const Text('Auto mute videos(AnimatedBuilder)'),
                  subtitle: const Text(
                    'Videos will be muted by default\n(currently not connected)',
                    style: TextStyle(fontSize: Sizes.size12),
                  ),
                  activeColor: Theme.of(context).primaryColor,
                  // activeThumbImage: const AssetImage('assets/images/1.jpeg'),
                ),
              ),
              // SwitchListTile.adaptive(
              //   value: VideoConfigData.of(context).autoMute,
              //   onChanged: (value) => VideoConfigData.of(context).toggleMuted(),
              //   title: const Text('Auto mute videos'),
              //   subtitle: const Text(
              //     'Videos will be muted by default',
              //     style: TextStyle(fontSize: Sizes.size12),
              //   ),
              //   activeColor: Theme.of(context).primaryColor,
              //   // activeThumbImage: const AssetImage('assets/images/1.jpeg'),
              // ),
              SwitchListTile.adaptive(
                value: _notifications,
                onChanged: _onChangeNotifications,
                title: const Text('Enable Notifications'),
                activeColor: Theme.of(context).primaryColor,
                // activeThumbImage: const AssetImage('assets/images/1.jpeg'),
              ),
              CheckboxListTile.adaptive(
                value: _marketingEmails,
                onChanged: _onChangeMarketingEmails,
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

                  if (!mounted) return;
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
                        onPressed: _cancelLogOut,
                        child: const Text("No"),
                      ),
                      CupertinoDialogAction(
                        onPressed: _logOut,
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
                        onPressed: _cancelLogOut,
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: _logOut,
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
                        onPressed: _cancelLogOut,
                        child: const Text("No"),
                      ),
                      CupertinoDialogAction(
                        onPressed: _logOut,
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
                        onPressed: _cancelLogOut,
                        isDefaultAction: true,
                        child: const Text('No'),
                      ),
                      CupertinoActionSheetAction(
                        onPressed: _logOut,
                        isDestructiveAction: true,
                        child: const Text('Yes'),
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

          // Column(
          //   children: [
          //     CupertinoActivityIndicator(
          //       radius: 40,
          //       // animating: false,
          //     ),
          //     CircularProgressIndicator(),
          //     /* CircularProgressIndicator.adaptive => 현재 플랫폼에 따라 위 indecators 둘 중 하나의 형태로 출력 */
          //     CircularProgressIndicator.adaptive(),
          //   ],
          // )

          /* ListWheelScrollView => 원통형 스크롤 위젯 */
          // ListWheelScrollView(
          //   itemExtent: 200,
          //   diameterRatio: 1.3,
          //   offAxisFraction: -0.5,
          //   // useMagnifier: true,
          //   // magnification: 1.5,
          //   children: [
          //     for (var x in [1, 2, 3, 5, 5, 6, 2, 2, 43, 53, 6, 5, 353, 434, 234])
          //       FractionallySizedBox(
          //         widthFactor: 1,
          //         child: Container(
          //           color: Colors.teal,
          //           alignment: Alignment.center,
          //           child: const Text(
          //             'Pick me!',
          //             style: TextStyle(
          //               color: Colors.white,
          //               fontSize: Sizes.size36,
          //             ),
          //           ),
          //         ),
          //       )
          //   ],
          // ),
        ),
      ),
    );
  }
}
