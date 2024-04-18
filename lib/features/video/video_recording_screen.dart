import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/video/video_preview_screen.dart';
import 'package:tiktok_clone/features/video/widgets/flash_mode_button.dart';
import 'package:tiktok_clone/utils/navigator_redirection.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  bool _hasPermission = false;
  bool _permissionDenied = false;
  bool _isInitialized = false;
  bool _isSelfieMode = false;

  late CameraController _cameraController;
  FlashMode _flashMode = FlashMode.auto;

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final Animation<double> _buttonAnimation = Tween(
    begin: 1.0,
    end: 1.3,
  ).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );
  late final Animation<double> _progressAnimation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(_progressAnimationController);

  @override
  void initState() {
    super.initState();
    initPermissions();
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> initPermissions() async {
    final cameraPermission = await Permission.camera.request();
    final micPermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    var gotPermission = !cameraDenied && !micDenied;
    _hasPermission = gotPermission;
    _permissionDenied = !gotPermission;
    if (gotPermission) await initCamera();

    setState(() {});
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();

    if (cameras.isEmpty) return;

    _cameraController = CameraController(
      // cameras[0] = back camera
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
      enableAudio: false, // Android Emulator 사용 시 자체적 오류 방지
    );

    await _cameraController.initialize();
    // only for iOS - 영상과 오디오의 싱크 불일치 예방
    await _cameraController.prepareForVideoRecording();

    _isInitialized = _cameraController.value.isInitialized;
    _flashMode = _cameraController.value.flashMode;
    setState(() {});
  }

  void _toggleSelfieMode() {
    _isSelfieMode = !_isSelfieMode;
    initCamera();
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    setState(() {
      _flashMode = newFlashMode;
    });
  }

  Future<void> _startRecording(TapDownDetails details) async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final file = await _cameraController.stopVideoRecording();

    // 사진
    // await _cameraController.takePicture();
    // print('+++++++++++++++++++++++ fileName: ${file.name}');
    // print('+++++++++++++++++++++++ filePath: ${file.path}');

    if (!mounted) return;

    redirectToScreen(
      context: context,
      targetScreen: VideoPreviewScreen(
        video: file,
        isPicked: false,
      ),
    );
  }

  Future<void> _onPressPickVideo() async {
    // ImageSource.camera => 기기의 카메라 앱 open
    // 직접 구현 대신 기기의 카메라를 사용하면 영상의 길이를 제한할 수 없으므로 필요에 따른 고려 필요
    // final video = await ImagePicker().pickVideo(source: ImageSource.camera);

    // ImageSource.gallery => 기기의 갤러리 open
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    // when user picked nothing
    if (video == null) return;

    if (!mounted) return;

    redirectToScreen(
      context: context,
      targetScreen: VideoPreviewScreen(
        video: video,
        isPicked: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: !_hasPermission && !_isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _permissionDenied
                        ? 'Permission Denied.\nPleas go to App Settings.'
                        : 'Initializing...',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: Sizes.size20,
                    ),
                  ),
                  Gaps.v20,
                  const CircularProgressIndicator.adaptive(),
                ],
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  CameraPreview(_cameraController),
                  Positioned(
                    top: Sizes.size32,
                    right: Sizes.size1,
                    child: Column(
                      children: [
                        IconButton(
                          color: Colors.white,
                          onPressed: _toggleSelfieMode,
                          icon: const Icon(
                            Icons.cameraswitch,
                            size: Sizes.size28,
                          ),
                        ),
                        Gaps.v10,
                        FlashModeButton(
                          icon: Icons.flash_off_rounded,
                          setFlashMode: _setFlashMode,
                          currentFlashMode: _flashMode,
                          buttonFlashMode: FlashMode.off,
                        ),
                        Gaps.v10,
                        FlashModeButton(
                          icon: Icons.flash_on_rounded,
                          setFlashMode: _setFlashMode,
                          currentFlashMode: _flashMode,
                          buttonFlashMode: FlashMode.always,
                        ),
                        Gaps.v10,
                        FlashModeButton(
                          icon: Icons.flash_auto_rounded,
                          setFlashMode: _setFlashMode,
                          currentFlashMode: _flashMode,
                          buttonFlashMode: FlashMode.auto,
                        ),
                        Gaps.v10,
                        FlashModeButton(
                          icon: Icons.flashlight_on_rounded,
                          setFlashMode: _setFlashMode,
                          currentFlashMode: _flashMode,
                          buttonFlashMode: FlashMode.torch,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: Sizes.size80 + Sizes.size10,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        // Spacer => 빈 공간
                        const Spacer(),
                        GestureDetector(
                          onTapDown: _startRecording,
                          onTapUp: (details) => _stopRecording(),
                          onVerticalDragUpdate: _onDragWhileRecording,
                          child: ScaleTransition(
                            scale: _buttonAnimation,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: Sizes.size60 + Sizes.size14,
                                  height: Sizes.size60 + Sizes.size14,
                                  child: CircularProgressIndicator(
                                    color: Colors.red.shade400,
                                    strokeWidth: Sizes.size5,
                                    value: _progressAnimationController.value,
                                  ),
                                ),
                                Container(
                                  width: Sizes.size60,
                                  height: Sizes.size60,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            // 클릭 적용 범위 제한을 위한 Container - center
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _onPressPickVideo,
                              icon: const FaIcon(
                                FontAwesomeIcons.image,
                                color: Colors.white,
                                size: Sizes.size28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
