import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';

import 'my_colors.dart';

class MyStyles {
  static final String fontStyle = 'Roboto';
  static final String fontStyleSplashScreen = 'Pacifico';
  static final String fontStyleNumber = 'Segoe UI';

  static final TextStyle buttonTextStyle = TextStyle(
    fontFamily: fontStyle,
    fontSize: MyValues.appBarFontSize,
    color: MyColors.white,
    fontWeight: FontWeight.bold,
  );

  static final EdgeInsetsGeometry buttonMargins = EdgeInsets.only(
    top: 16,
    bottom: 16,
    left: 64,
    right: 64,
  );

  static final EdgeInsetsGeometry buttonPadding = EdgeInsets.only(
    top: 16,
    bottom: 16,
  );

  static final EdgeInsetsGeometry topTextMargins = EdgeInsets.only(
    left: 32,
    right: 32,
  );

  static final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10.0),
  );

  static final TextStyle appBarTextStyle = TextStyle(
    fontFamily: fontStyle,
    fontWeight: FontWeight.normal,
    fontSize: MyValues.appBarFontSize,
    color: MyColors.white,
  );

  static final TextStyle splashScreenTextStyle = TextStyle(
    fontFamily: fontStyleSplashScreen,
    fontWeight: FontWeight.w500,
    fontSize: MyValues.appBarFontSize,
    color: MyColors.secondaryTheme,
  );

  static final TextStyle howToTextStyle = TextStyle(
    fontSize: MyValues.howToTextFontSize,
    color: MyColors.white,
  );
}