import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';

/// Contains text shown on the help screens
class HelpScreenTextWidget extends StatelessWidget {
  final String text;

  const HelpScreenTextWidget({@required this.text, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: topTextMargins,
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: howToTextStyle,
          textDirection: TextDirection.ltr,
        ),
      );
}
