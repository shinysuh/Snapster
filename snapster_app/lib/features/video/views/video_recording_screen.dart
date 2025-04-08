import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:snapster_app/constants/gaps.dart';
import 'package:snapster_app/constants/sizes.dart';
import 'package:snapster_app/features/video/views/video_preview_screen.dart';
import 'package:snapster_app/features/video/views/widgets/flash_mode_button.dart';
import 'package:snapster_app/utils/navigator_redirection.dart';

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = 'postVideo';
  static const String routeURL = '/upload';

  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

/* 향후 다양한 카메라 기능 구현 시, CamerAwsome 패키지가 더 좋음 */
class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _permissionDenied = false;
  bool _isInitialized = false;
  bool _isSelfieMode = false;

  // iOS 개발환경에서 카메라 block
  late final bool _noCamera = kDebugMode && Platform.isIOS;

  late double _maxZoom;
  late double _minZoom;
  double _currentZoom = 0.0;

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

    if (!_noCamera) {
      initPermissions();
    } else {
      _hasPermission = true; // iOS 개발환경에서 Column 화면만 출력되도록 설정
    }

    WidgetsBinding.instance.addObserver(this);

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
    WidgetsBinding.instance.removeObserver(this);
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
    // iOS 오류 방지
    if (!_noCamera) _cameraController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_noCamera) return; // iOS 오류 방지
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.hidden) {
      _cameraController.dispose();
    }

    if (state == AppLifecycleState.resumed) {
      initCamera();
    }
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

    _maxZoom = await _cameraController.getMaxZoomLevel(); // 10.0
    _minZoom = await _cameraController.getMinZoomLevel(); // 1.0

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
    _currentZoom = 0.0;
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

  Future<void> _onDragWhileRecording(DragUpdateDetails details) async {
    if (!_cameraController.value.isInitialized) return;

    // 위 offset y -
    // 아래 offset y +
    var dragDelta = _currentZoom + (-details.delta.dy * 0.05);
    _currentZoom = dragDelta > _maxZoom
        ? _maxZoom
        : dragDelta < _minZoom
            ? _minZoom
            : dragDelta;

    await _cameraController.setZoomLevel(_currentZoom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: !_hasPermission
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
                  if (!_noCamera && _isInitialized)
                    CameraPreview(_cameraController),
                  const Positioned(
                    top: Sizes.size32,
                    left: Sizes.size4,
                    child: CloseButton(
                      color: Colors.white,
                    ),
                  ),
                  if (!_noCamera)
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
