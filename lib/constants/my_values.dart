/// Stores some numbers used within the app
part of './constants.dart';

// Used for positioning CameraWidget
const double pad = 32;
double verticalPadding;
double horizontalPadding;
int appBarHeight = 56;

// UI stuff
const double topTextFontSize = 40;
const double appBarFontSize = 25;
const double howToTextFontSize = 30;
const double buttonTextFontSize = 40;
const double dropDownMenuFontSize = 40;
const double tileFontSize = 15;
const double numberFontSize = 15;

// Solving will time out after this time has elapsed
const int maxSolveTime = 30000;

final FirebasePerformance firebasePerformance = FirebasePerformance.instance;
final Trace solveSudokuButtonPressedTrace = firebasePerformance.newTrace('solve-sudoku-button-pressed');
final Trace takePhotoButtonPressedTrace = firebasePerformance.newTrace('take-photo-button-pressed');
