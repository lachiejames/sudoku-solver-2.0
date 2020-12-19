/// Stores some numbers used within the app

library my_values;

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

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

final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

final FirebasePerformance firebasePerformance = FirebasePerformance.instance;
final Trace solveMySudokuButtonPressedTrace =
    firebasePerformance.newTrace("solve-my-sudoku-button-pressed");
final Trace takePhotoButtonPressedTrace =
    firebasePerformance.newTrace("take-photo-button-pressed");
final Trace yesSolveItButtonPressedTrace =
    firebasePerformance.newTrace("yes-solve-it-button-pressed");
