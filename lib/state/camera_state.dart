import 'package:camera/camera.dart';

/// All state relating to the Camera
class CameraState {
  int croppedImageWidth;
  final CameraController cameraController;

  CameraState({this.cameraController});

  CameraState copyWith({CameraController cameraController}) {
    return CameraState(cameraController: cameraController);
  }

  static CameraState initCameraState() {
    return CameraState(
      cameraController: null,
    );
  }
}
