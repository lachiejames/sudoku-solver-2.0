import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraState {
  final CameraDescription cameraDescription;
  final CameraController cameraController;

  CameraState({
    @required this.cameraDescription,
    @required this.cameraController,
  }) {
    assert(this.cameraDescription != null);
    assert(this.cameraController != null);
  }

  blah() {}

  CameraState copyWith({
    CameraDescription cameraDescription,
    CameraController cameraController,
  }) {
    return CameraState(
      cameraDescription: cameraDescription ?? this.cameraDescription,
      cameraController: cameraController ?? this.cameraController,
    );
  }
}
