import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/screens/solve_with_camera_screen.dart';
import 'package:sudoku_solver_2/widgets/shared/size_animated_route.dart';

/// Lives on the HomeScreen, navigating users to the SolveWithCameraButtonWidget
class SolveWithCameraButtonWidget extends StatefulWidget {
  const SolveWithCameraButtonWidget({Key key}) : super(key: key);

  @override
  _SolveWithCameraButtonWidgetState createState() => _SolveWithCameraButtonWidgetState();
}

class _SolveWithCameraButtonWidgetState extends State<SolveWithCameraButtonWidget> {
  @override
  Widget build(BuildContext context) => Container(
        margin: buttonMargins,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton.icon(
              icon: const Icon(
                Icons.camera_alt,
                color: white,
                size: 40,
              ),
              shape: buttonShape,
              padding: buttonPadding,
              color: pink,
              onPressed: () async {
                await playSound(buttonPressedSound);
                await logEvent('button_solve_with_camera');
                await _navigateToSolveWithCameraScreen(context);
              },
              label: const Text(
                solveWithCameraButtonText,
                style: buttonTextStyle,
              ),
            ),
          ),
        ),
      );

  Future<void> _navigateToSolveWithCameraScreen(BuildContext context) async {
    await Navigator.push(
      context,
      SizeAnimatedRoute(
        nextPage: const SolveWithCameraScreen(),
        routeSettings: const RouteSettings(name: '/solve-with-camera'),
      ),
    );
  }
}
