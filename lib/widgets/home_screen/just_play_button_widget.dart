import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/screens/just_play_screen.dart';
import 'package:sudoku_solver_2/widgets/shared/size_animated_route.dart';

/// Lives on the HomeScreen, navigating users to the JustPlayScreen
class JustPlayButtonWidget extends StatelessWidget {
  const JustPlayButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        margin: buttonMargins,
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              shape: buttonShape,
              padding: buttonPadding,
              color: pink,
              onPressed: () async {
                await playSound(buttonPressedSound);
                await logEvent('button_just_play');
                await _navigateToJustPlayScreen(context);
              },
              child: const Text(
                justPlayButtonText,
                style: buttonTextStyle,
              ),
            ),
          ),
        ),
      );

  Future<void> _navigateToJustPlayScreen(BuildContext context) async {
    await Navigator.push(
      context,
      SizeAnimatedRoute(
        nextPage: const JustPlayScreen(),
        routeSettings: const RouteSettings(name: '/just-play'),
      ),
    );
  }
}
