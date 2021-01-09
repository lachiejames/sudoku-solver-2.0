import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/screens/solve_with_touch_screen.dart';
import 'package:sudoku_solver_2/widgets/shared/size_animated_route.dart';

/// Lives on the HomeScreen, navigating users to the SolveWithTouchButtonWidget
class SolveWithTouchButtonWidget extends StatelessWidget {
  SolveWithTouchButtonWidget({Key key}) : super(key: key);

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
            left: 48,
            right: 48,
          ),
          color: constants.pink,
          child: Text(
            constants.solveWithTouchButtonText,
            style: constants.buttonTextStyle,
          ),
          onPressed: () async {
            await _navigateToSolveWithTouchScreen(context);
            await constants.firebaseAnalytics.logEvent(name: 'button_solve_with_touch');
            await constants.playSound(constants.buttonPressedSound);
          },
        ),
      ),
    );
  }

  Future<void> _navigateToSolveWithTouchScreen(BuildContext context) async {
    await Navigator.push(
      context,
      SizeAnimatedRoute(
        nextPage: SolveWithTouchScreen(),
        routeSettings: RouteSettings(name: '/solve-with-touch'),
      ),
    );
  }
}
