import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;

/// Contains text shown on the help screens
class HelpScreenTextWidget extends StatelessWidget {
  final String text;

  HelpScreenTextWidget({@required this.text, Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: constants.topTextMargins,
      child: Text(
        this.text,
        textAlign: TextAlign.left,
        style: constants.howToTextStyle,
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
