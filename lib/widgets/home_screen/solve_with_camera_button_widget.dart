import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/screens/solve_with_camera_screen.dart';

/// Lives on the HomeScreen, navigating users to the SolveWithCameraButtonWidget
class SolveWithCameraButtonWidget extends StatelessWidget {
  SolveWithCameraButtonWidget({Key key}) : super(key: key);

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
            left: 32,
            right: 32,
          ),
          color: my_colors.pink,
          child: Text(
            my_strings.solveWithCameraButtonText,
            style: my_styles.buttonTextStyle,
          ),
          onPressed: () {
            _navigateToSolveWithCameraScreen(context);
            FirebaseAnalytics().logEvent(name: 'solve_with_camera_button', parameters: null);
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
