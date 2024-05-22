import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/video/view_models/video_upload_view_model.dart';
import 'package:tiktok_clone/features/video/views/widgets/video_detail_form.dart';
import 'package:tiktok_clone/utils/tap_to_unfocus.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  final XFile video;
  final bool isPicked;

  const VideoPreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen> {
  late final VideoPlayerController _videoPlayerController;
  Map<String, String> videoDetail = {
    'title': '',
    'description': '',
  };
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _initVideo().then((value) => showModalBottom());
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
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

  void showModalBottom() {
    showModalBottomSheet(
      context: context,
      // backgroundColor: transparent 설정으로 Scaffold의 설정이 보일 수 있게 됨 (borderRadius 도 마찬가지)
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => VideoDetailForm(
        videoDetail: videoDetail,
        onChangeVideoDetail: _setVideoDetail,
      ),
    );
  }

  Future<void> _saveToGallery() async {
    if (_isSaved) return;

    await GallerySaver.saveVideo(widget.video.path, albumName: 'TikTok Clone');

    setState(() {
      _isSaved = true;
    });
  }

  void _setVideoDetail(String field, String? info) {
    if (info != null) {
      setState(() {
        videoDetail[field] = info;
      });
    }
  }

  void _onTapUpload() {
    ref.read(videoUploadProvider.notifier).uploadVideo(
          context: context,
          video: File(widget.video.path),
          title: videoDetail['title'] ?? '',
          description: videoDetail['description'] ?? '',
        );
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = ref.watch(videoUploadProvider).isLoading;

    return GestureDetector(
      onTap: () => onTapOutsideAndDismissKeyboard(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: () => showModalBottom(),
          child: const FaIcon(FontAwesomeIcons.penToSquare),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Preview video'),
          actions: [
            if (!widget.isPicked)
              IconButton(
                onPressed: _saveToGallery,
                icon: FaIcon(
                  _isSaved ? FontAwesomeIcons.check : FontAwesomeIcons.download,
                ),
              ),
            IconButton(
              onPressed: isLoading ? null : _onTapUpload,
              icon: isLoading
                  ? const SizedBox(
                      height: Sizes.size24,
                      width: Sizes.size24,
                      child: CircularProgressIndicator())
                  : const FaIcon(
                      FontAwesomeIcons.cloudArrowUp,
                    ),
            ),
          ],
        ),
        body: !_videoPlayerController.value.isInitialized
            ? null
            : VideoPlayer(_videoPlayerController),
      ),
    );
  }
}
