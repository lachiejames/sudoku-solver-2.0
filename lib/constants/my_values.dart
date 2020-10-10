/// Stores some numbers used within the app

library my_values;

import 'package:camera/camera.dart';

// Set when app initialises
double screenHeight;
double screenWidth;
double cameraHeight;
double cameraWidth;

CameraController cameraController;

// Used for positioning CameraWidget
final double pad = 32;
double verticalPadding;
double horizontalPadding;

// UI stuff
final double topTextFontSize = 40;
final double appBarFontSize = 30;
final double howToTextFontSize = 40;
final double buttonTextFontSize = 40;
final double dropDownMenuFontSize = 40;
final double toastFontSize = 15;
final double tileFontSize = 15;
final double numberFontSize = 15;

// Solving will time out after this time has elapsed
final int maxSolveTime = 30000;
