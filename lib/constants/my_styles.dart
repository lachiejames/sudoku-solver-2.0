/// Stores some styles used within the app
part of './constants.dart';

const String fontStyle = 'Roboto';
const String fontStyleSplashScreen = 'Pacifico';
const String fontStyleNumber = 'Segoe UI';

const TextStyle buttonTextStyle = TextStyle(
  fontFamily: fontStyle,
  fontSize: 30,
  color: white,
  fontWeight: FontWeight.bold,
);

const EdgeInsetsGeometry buttonMargins = EdgeInsets.only(
  top: 32,
  bottom: 16,
  left: 32,
  right: 32,
);

const EdgeInsetsGeometry buttonPadding = EdgeInsets.only(
  top: 16,
  bottom: 16,
  left: 32,
  right: 32,
);

const EdgeInsetsGeometry topTextMargins = EdgeInsets.only(
  top: 32,
  bottom: 32,
  left: 32,
  right: 32,
);

final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(10),
);

const TextStyle appBarTextStyle = TextStyle(
  fontFamily: fontStyle,
  fontWeight: FontWeight.normal,
  fontSize: appBarFontSize,
  color: white,
);

const TextStyle splashScreenTextStyle = TextStyle(
  fontFamily: fontStyleSplashScreen,
  fontWeight: FontWeight.w500,
  fontSize: appBarFontSize,
  color: pink,
);

const TextStyle howToTextStyle = TextStyle(
  fontSize: howToTextFontSize,
  color: white,
);

const TextStyle dropDownMenuTextStyle = TextStyle(
  fontWeight: FontWeight.w500,
  color: black,
);

const TextStyle tileTextStyle = TextStyle(
  fontSize: tileFontSize,
  fontFamily: fontStyleNumber,
  fontWeight: FontWeight.w400,
);

const TextStyle tileWithRemovableValueTextStyle = TextStyle(
  fontSize: tileFontSize,
  color: red,
);
