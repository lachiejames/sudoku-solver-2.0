import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;

/// Contains text shown on the help screens
class HelpScreenTextWidget extends StatefulWidget {
  final String text;
  HelpScreenTextWidget({@required this.text, Key key}) : super(key: key);

  @override
  _HelpScreenTextWidgetState createState() => _HelpScreenTextWidgetState();
}

class _HelpScreenTextWidgetState extends State<HelpScreenTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: my_styles.topTextMargins,
      child: Text(
        widget.text,
        textAlign: TextAlign.left,
        style: my_styles.howToTextStyle,
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
