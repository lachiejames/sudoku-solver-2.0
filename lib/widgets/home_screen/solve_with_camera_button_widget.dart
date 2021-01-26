import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/constants/constants.dart';
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
      margin: constants.buttonMargins,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: RaisedButton(
          shape: constants.buttonShape,
          padding: EdgeInsets.only(
            top: 16,
            bottom: 16,
            left: 32,
            right: 32,
          ),
          color: constants.pink,
          child: Text(
            constants.solveWithCameraButtonText,
            style: constants.buttonTextStyle,
          ),
          onPressed: () async {
            await constants.playSound(constants.buttonPressedSound);
            await logEvent('button_solve_with_camera');
            await _navigateToSolveWithCameraScreen(context);
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
