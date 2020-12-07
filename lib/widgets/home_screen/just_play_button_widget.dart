import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/screens/just_play_screen.dart';

/// Lives on the HomeScreen, navigating users to the JustPlayScreen
class JustPlayButtonWidget extends StatelessWidget {
  JustPlayButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: my_styles.buttonMargins,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: RaisedButton(
          shape: my_styles.buttonShape,
          padding: EdgeInsets.only(
            top: 16,
            bottom: 16,
            left: 50,
            right: 50,
          ),
          color: my_colors.pink,
          child: Text(
            my_strings.justPlayButtonText,
            style: my_styles.buttonTextStyle,
          ),
          onPressed: () {
            _navigateToJustPlayScreen(context);
          },
        ),
      ),
    );
  }

  void _navigateToJustPlayScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JustPlayScreen(),
        settings: RouteSettings(name: '/just-play'),
      ),
    );
  }
}
