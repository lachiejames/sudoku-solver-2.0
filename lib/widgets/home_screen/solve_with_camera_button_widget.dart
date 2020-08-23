import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/screens/solve_with_camera_screen.dart';

class SolveWithCameraButtonWidget extends StatelessWidget {
  SolveWithCameraButtonWidget({Key key}) : super(key: key);

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
            left: 32,
            right: 32,
          ),
          color: MyColors.pink,
          child: Text(
            MyStrings.solveWithCameraButtonText,
            style: MyStyles.buttonTextStyle,
          ),
          onPressed: () {
            _navigateToSolveWithCameraScreen(context);
          },
        ),
      ),
    );
  }

  void _navigateToSolveWithCameraScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SolveWithCameraScreen(),
      ),
    );
  }
}