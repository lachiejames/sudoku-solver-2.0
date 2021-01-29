import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/screens/solve_with_touch_screen.dart';
import 'package:sudoku_solver_2/widgets/shared/size_animated_route.dart';

/// Lives on the HomeScreen, navigating users to the SolveWithTouchButtonWidget
class SolveWithTouchButtonWidget extends StatelessWidget {
  const SolveWithTouchButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        margin: buttonMargins,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: RaisedButton(
            shape: buttonShape,
            padding: const EdgeInsets.only(
              top: 16,
              bottom: 16,
              left: 48,
              right: 48,
            ),
            color: pink,
            onPressed: () async {
              await playSound(buttonPressedSound);
              await logEvent('button_solve_with_touch');
              await _navigateToSolveWithTouchScreen(context);
            },
            child: const Text(
              solveWithTouchButtonText,
              style: buttonTextStyle,
            ),
          ),
        ),
      );

  Future<void> _navigateToSolveWithTouchScreen(BuildContext context) async {
    await Navigator.push(
      context,
      SizeAnimatedRoute(
        nextPage: const SolveWithTouchScreen(),
        routeSettings: const RouteSettings(name: '/solve-with-touch'),
      ),
    );
  }
}
