import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoTags extends StatelessWidget {
  const VideoTags({
    super.key,
    required this.tag,
  });

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Text(
      '#$tag',
      style: const TextStyle(
        color: Colors.white,
        fontSize: Sizes.size16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
