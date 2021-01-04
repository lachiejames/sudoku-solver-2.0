import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/screens/solve_with_camera_screen.dart';
import 'package:sudoku_solver_2/widgets/shared/size_animated_route.dart';

/// Lives on the HomeScreen, navigating users to the SolveWithCameraButtonWidget
class SolveWithCameraButtonWidget extends StatefulWidget {
  SolveWithCameraButtonWidget({Key key}) : super(key: key);

  @override
  _SolveWithCameraButtonWidgetState createState() => _SolveWithCameraButtonWidgetState();
}

class _SolveWithCameraButtonWidgetState extends State<SolveWithCameraButtonWidget> {

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
          onPressed: () async {
            await _navigateToSolveWithCameraScreen(context);
            await my_values.firebaseAnalytics.logEvent(name: 'button_solve_with_camera');
          },
        ),
      ),
    );
  }

  Future<void> _navigateToSolveWithCameraScreen(BuildContext context) async {
    await Navigator.push(
      context,
      SizeAnimatedRoute(
        nextPage: SolveWithCameraScreen(),
        routeSettings: RouteSettings(name: '/solve-with-camera'),
      ),
    );
  }
}
