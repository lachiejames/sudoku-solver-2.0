import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';

/// Stores some styles used within the app
class MyStyles {
  static final String fontStyle = 'Roboto';
  static final String fontStyleSplashScreen = 'Pacifico';
  static final String fontStyleNumber = 'Segoe UI';

  static final TextStyle buttonTextStyle = TextStyle(
    fontFamily: fontStyle,
    fontSize: 20,
    color: MyColors.white,
    fontWeight: FontWeight.bold,
  );

  static final EdgeInsetsGeometry buttonMargins = EdgeInsets.only(
    top: 32,
    bottom: 16,
    left: 32,
    right: 32,
  );

  static final EdgeInsetsGeometry buttonPadding = EdgeInsets.only(
    top: 16,
    bottom: 16,
    left: 32,
    right: 32,
  );

  static final EdgeInsetsGeometry topTextMargins = EdgeInsets.only(
    top: 32,
    bottom: 32,
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
    color: MyColors.pink,
  );

  static final TextStyle howToTextStyle = TextStyle(
    fontSize: MyValues.howToTextFontSize,
    color: MyColors.white,
  );

  static final TextStyle dropDownMenuTextStyle = TextStyle(
    fontWeight: FontWeight.w500,
    color: MyColors.black,
  );

  static final TextStyle tileTextStyle = TextStyle(
    fontSize: MyValues.tileFontSize,
    fontFamily: MyStyles.fontStyleNumber,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle tileWithRemovableValueTextStyle = TextStyle(
    fontSize: MyValues.tileFontSize,
    color: MyColors.red,
  );
}
