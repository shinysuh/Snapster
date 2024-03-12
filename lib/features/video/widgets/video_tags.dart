import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoTags extends StatefulWidget {
  const VideoTags({
    super.key,
    required this.tag,
  });

  final String tag;

  @override
  State<VideoTags> createState() => _VideoTagsState();
}

class _VideoTagsState extends State<VideoTags> {
  @override
  Widget build(BuildContext context) {
    return Text(
      '#${widget.tag}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: Sizes.size16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
