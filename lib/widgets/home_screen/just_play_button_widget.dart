import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/screens/just_play_screen.dart';

class JustPlayButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: MyStyles.buttonMargins,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: RaisedButton(
          shape: MyStyles.buttonShape,
          padding: EdgeInsets.only(
            top: 16,
            bottom: 16,
            left: 100,
            right: 100,
          ),
          color: MyColors.pink,
          child: Text(
            MyStrings.appBarTextJustPlayScreen,
            style: MyStyles.buttonTextStyle,
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
      ),
    );
  }
}
