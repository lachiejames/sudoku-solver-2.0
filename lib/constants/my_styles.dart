/// Stores some styles used within the app

library my_styles;

import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;

final String fontStyle = 'Roboto';
final String fontStyleSplashScreen = 'Pacifico';
final String fontStyleNumber = 'Segoe UI';

final TextStyle buttonTextStyle = TextStyle(
  fontFamily: fontStyle,
  fontSize: 20,
  color: my_colors.white,
  fontWeight: FontWeight.bold,
);

final EdgeInsetsGeometry buttonMargins = EdgeInsets.only(
  top: 32,
  bottom: 16,
  left: 32,
  right: 32,
);

final EdgeInsetsGeometry buttonPadding = EdgeInsets.only(
  top: 16,
  bottom: 16,
  left: 32,
  right: 32,
);

final EdgeInsetsGeometry topTextMargins = EdgeInsets.only(
  top: 32,
  bottom: 32,
  left: 32,
  right: 32,
);

final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10.0),
);

final TextStyle appBarTextStyle = TextStyle(
  fontFamily: fontStyle,
  fontWeight: FontWeight.normal,
  fontSize: my_values.appBarFontSize,
  color: my_colors.white,
);

final TextStyle splashScreenTextStyle = TextStyle(
  fontFamily: fontStyleSplashScreen,
  fontWeight: FontWeight.w500,
  fontSize: my_values.appBarFontSize,
  color: my_colors.pink,
);

final TextStyle howToTextStyle = TextStyle(
  fontSize: my_values.howToTextFontSize,
  color: my_colors.white,
);

final TextStyle dropDownMenuTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  color: my_colors.black,
);

final TextStyle tileTextStyle = TextStyle(
  fontSize: my_values.tileFontSize,
  fontFamily: fontStyleNumber,
  fontWeight: FontWeight.w400,
);

final TextStyle tileWithRemovableValueTextStyle = TextStyle(
  fontSize: my_values.tileFontSize,
  color: my_colors.red,
);
