import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

class MyMockHelper {
  static String imagePath;

  static void setPictureMock() async {
    await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'startImageStream') {
        dynamic mockData;
        cameraImage = CameraImage(mockData);
      }
      return Future.value();
    });
  }

  static void deletePictureMock() async {
    await MethodChannel('plugins.flutter.io/camera').setMockMethodCallHandler(null);
  }
}
