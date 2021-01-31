import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/screens/solve_with_touch_screen.dart';
import 'package:sudoku_solver_2/widgets/shared/size_animated_route.dart';

/// Lives on the HomeScreen, navigating users to the SolveWithTouchButtonWidget
class SolveWithTouchButtonWidget extends StatelessWidget {
  const SolveWithTouchButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: buttonMargins,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton.icon(
              icon: const Icon(
                Icons.touch_app,
                color: white,
                size: 40,
              ),
              shape: buttonShape,
              padding: buttonPadding,
              color: pink,
              onPressed: () async {
                await playSound(buttonPressedSound);
                await logEvent('button_solve_with_touch');
                await _navigateToSolveWithTouchScreen(context);
              },
              label: const Text(
                solveWithTouchButtonText,
                style: buttonTextStyle,
              ),
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
