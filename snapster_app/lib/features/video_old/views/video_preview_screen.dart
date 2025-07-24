import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/view_models/http_video_upload_view_model.dart';
import 'package:snapster_app/features/video_old/view_models/playback_config_view_model.dart';
import 'package:snapster_app/features/video_old/views/widgets/video_detail_form.dart';
import 'package:snapster_app/generated/l10n.dart';
import 'package:snapster_app/utils/exception_handlers/error_snack_bar.dart';
import 'package:snapster_app/utils/tap_to_unfocus.dart';
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
  static const String title = 'title';
  static const String description = 'description';
  Map<String, String> videoDetail = {
    title: '',
    description: '',
  };
  bool _isSaved = false;
  bool _isAutoValidationTriggered = false;
  bool _isPlaying = true;

  late final bool _isMuted = ref.watch(playbackConfigProvider).muted;

  @override
  void initState() {
    super.initState();
    _initVideo();
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
    await _videoPlayerController.setVolume(_isMuted ? 0 : 1);
    await _videoPlayerController.play();

    // initialization 을 build 메소드가 알도록 하는 역할
    setState(() {});

    showDialogForm();
  }

  void showDialogForm() {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return VideoDetailForm(
    //       videoDetail: videoDetail,
    //       onChangeVideoDetail: _setVideoDetail,
    //       isAutoValidationTriggered: _isAutoValidationTriggered,
    //     );
    //   },
    // ).then((value) {
    //   setState(() {
    //     _isAutoValidationTriggered = false;
    //   });
    // });

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: VideoDetailForm(
            videoDetail: videoDetail,
            onChangeVideoDetail: _setVideoDetail,
            isAutoValidationTriggered: _isAutoValidationTriggered,
          ),
        );
      },
    ).then((value) {
      setState(() {
        _isAutoValidationTriggered = false;
      });
    });
  }

  Future<void> _saveToGallery() async {
    if (_isSaved) return;

    await GallerySaver.saveVideo(widget.video.path, albumName: 'Snapster');

    setState(() {
      _isSaved = true;
    });
  }

  void _setVideoDetail(Map<String, String> detail) {
    if (detail.isNotEmpty) {
      setState(() {
        videoDetail[title] = detail[title] ?? '';
        videoDetail[description] = detail[description] ?? '';
      });
    }
  }

  void _onTapUpload() {
    if (videoDetail[title] == null || videoDetail[title]!.trim() == '') {
      setState(() {
        _isAutoValidationTriggered = true;
      });

      showDialogForm();
      showCustomErrorSnack(context, S.of(context).setTheVideoTitle);
      return;
    }

    ref.read(httpVideoUploadProvider.notifier).uploadVideo(
          context: context,
          file: File(widget.video.path),
          title: videoDetail[title] ?? '',
          description: videoDetail[description] ?? '',
        );
  }

  void _togglePlay() {
    if (_isPlaying) {
      _videoPlayerController.pause();
      _isPlaying = false;
    } else {
      _videoPlayerController.play();
      _isPlaying = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var isLoading = ref.watch(httpVideoUploadProvider).isLoading;

    return GestureDetector(
      onTap: () => onTapOutsideAndDismissKeyboard(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialogForm(),
          backgroundColor: Colors.white,
          child: const FaIcon(
            FontAwesomeIcons.penToSquare,
            color: Colors.black,
          ),
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
            : GestureDetector(
                onTap: _togglePlay,
                child: VideoPlayer(_videoPlayerController),
              ),
      ),
    );
  }
}
