/// Stores some numbers used within the app

library my_values;

import 'dart:ui';

// Set when app initialises
Size screenSize;         // Size(360.0, 722.7)
Size cameraWidgetSize;   // Size(296.0, 296.0)
Size fullPhotoSize;      // Size(1280.0, 720.0)
Size sudokuPhotoSize;    // Size(1280.0, 720.0)
Size tilePhotoSize;      // Size(1280.0, 720.0)
Rect cameraWidgetRect;   // Rect.fromLTRB(32.0, 213.3, 328.0, 509.3)
Rect screenRect;         // Rect.fromLTRB(0.0, 0.0, 360.0, 722.7)
Rect sudokuPhotoRect;    // Rect.fromLTRB(138.4, 518.9, 1418.4, 1238.9)

// Used for positioning CameraWidget
final double pad = 32;
double verticalPadding;
double horizontalPadding;
int appBarHeight = 56;

// UI stuff
final double topTextFontSize = 40;
final double appBarFontSize = 25;
final double howToTextFontSize = 40;
final double buttonTextFontSize = 40;
final double dropDownMenuFontSize = 40;
final double toastFontSize = 15;
final double tileFontSize = 15;
final double numberFontSize = 15;

// Solving will time out after this time has elapsed
final int maxSolveTime = 30000;
