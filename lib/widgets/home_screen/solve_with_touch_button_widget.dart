import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/screens/solve_with_touch_screen.dart';

/// Lives on the HomeScreen, navigating users to the SolveWithTouchButtonWidget
class SolveWithTouchButtonWidget extends StatelessWidget {
  SolveWithTouchButtonWidget({Key key}) : super(key: key);

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
            left: 48,
            right: 48,
          ),
          color: my_colors.pink,
          child: Text(
            my_strings.solveWithTouchButtonText,
            style: my_styles.buttonTextStyle,
          ),
          onPressed: () {
            _navigateToSolveWithTouchScreen(context);
          },
        ),
      ),
    );
  }

  void _navigateToSolveWithTouchScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SolveWithTouchScreen(),
      ),
    );
  }
}
