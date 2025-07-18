import 'package:flutter/material.dart';
import 'package:snapster_app/common/widgets/video_config/video_config.dart';

bool isDarkMode(BuildContext context) =>
    screenModeConfig.value == ThemeMode.dark;
// 폰 설정 따르기
// MediaQuery.of(context).platformBrightness == Brightness.dark;
