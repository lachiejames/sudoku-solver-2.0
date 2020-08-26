class MyValues {
  // Set when app initialises
  static double screenHeight;
  static double screenWidth;
  static double cameraHeight;
  static double cameraWidth;

  // Used for positioning CameraWidget
  static final double pad = 32;
  static double verticalPadding = (screenHeight - cameraHeight) / 2 - pad;
  static double horizontalPadding = pad;

  // UI stuff
  static final double topTextFontSize = 40;
  static final double appBarFontSize = 30;
  static final double howToTextFontSize = 40;
  static final double buttonTextFontSize = 40;
  static final double dropDownMenuFontSize = 40;
  static final double toastFontSize = 15;
  static final double tileFontSize = 15;
  static final double numberFontSize = 15;

  // Solving will time out after this time has elapsed
  static final int maxSolveTime = 30000;
}
