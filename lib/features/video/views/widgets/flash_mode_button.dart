import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class FlashModeButton extends StatelessWidget {
  final IconData icon;
  final FlashMode currentFlashMode, buttonFlashMode;
  final Function setFlashMode;

  const FlashModeButton({
    super.key,
    required this.icon,
    required this.setFlashMode,
    required this.currentFlashMode,
    required this.buttonFlashMode,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: currentFlashMode == buttonFlashMode
          ? Colors.amber.shade200
          : Colors.white,
      onPressed: () => setFlashMode(buttonFlashMode),
      icon: Icon(
        icon,
        size: Sizes.size28,
      ),
    );
  }
}
