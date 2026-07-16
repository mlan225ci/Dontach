import 'package:camera/camera.dart';
import 'package:gal/gal.dart';
import 'package:permission_handler/permission_handler.dart';

class IntruderCaptureService {
  CameraController? _controller;
  bool _isReady = false;

  bool get isReady => _isReady;

  Future<bool> prepare() async {
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) return false;

    if (!await Gal.hasAccess()) {
      await Gal.requestAccess();
    }
    if (!await Gal.hasAccess()) return false;

    final cameras = await availableCameras();
    if (cameras.isEmpty) return false;

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    await _controller?.dispose();
    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _controller!.initialize();
    _isReady = true;
    return true;
  }

  Future<bool> captureAndSave() async {
    final controller = _controller;
    if (!_isReady || controller == null || !controller.value.isInitialized) {
      return false;
    }

    try {
      final photo = await controller.takePicture();
      await Gal.putImage(photo.path, album: 'Dontach');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> release() async {
    await _controller?.dispose();
    _controller = null;
    _isReady = false;
  }
}
