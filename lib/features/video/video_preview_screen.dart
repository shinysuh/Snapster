import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends StatefulWidget {
  final XFile video;
  final bool isPicked;

  const VideoPreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  @override
  State<VideoPreviewScreen> createState() => _VideoPreviewScreenState();
}

class _VideoPreviewScreenState extends State<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;

  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    _videoPlayerController =
        VideoPlayerController.file(File(widget.video.path));

    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();

    // initialization 을 build 메소드가 알도록 하는 역할
    setState(() {});
  }

  Future<void> _saveToGallery() async {
    if (_isSaved) return;

    await GallerySaver.saveVideo(widget.video.path, albumName: 'TikTok Clone');

    setState(() {
      _isSaved = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview video'),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(
                _isSaved ? FontAwesomeIcons.check : FontAwesomeIcons.download,
              ),
            ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? VideoPlayer(_videoPlayerController)
          : null,
    );
  }
}
