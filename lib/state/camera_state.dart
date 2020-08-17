import 'package:camera/camera.dart';

class CameraState {
  CameraDescription cameraDescription;
  CameraController cameraController;

  Future<void> initCamera() async {
    cameraDescription = (await availableCameras()).first;
    cameraController = CameraController(cameraDescription, ResolutionPreset.ultraHigh);
    cameraController.initialize();
  }
}
