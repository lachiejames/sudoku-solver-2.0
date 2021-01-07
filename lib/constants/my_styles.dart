/// Stores some styles used within the app
part of './constants.dart';

final String fontStyle = 'Roboto';
final String fontStyleSplashScreen = 'Pacifico';
final String fontStyleNumber = 'Segoe UI';

final TextStyle buttonTextStyle = TextStyle(
  fontFamily: fontStyle,
  fontSize: 20,
  color: white,
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
  fontSize: appBarFontSize,
  color: white,
);

final TextStyle splashScreenTextStyle = TextStyle(
  fontFamily: fontStyleSplashScreen,
  fontWeight: FontWeight.w500,
  fontSize: appBarFontSize,
  color: pink,
);

final TextStyle howToTextStyle = TextStyle(
  fontSize: howToTextFontSize,
  color: white,
);

final TextStyle dropDownMenuTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  color: black,
);

final TextStyle tileTextStyle = TextStyle(
  fontSize: tileFontSize,
  fontFamily: fontStyleNumber,
  fontWeight: FontWeight.w400,
);

final TextStyle tileWithRemovableValueTextStyle = TextStyle(
  fontSize: tileFontSize,
  color: red,
);
