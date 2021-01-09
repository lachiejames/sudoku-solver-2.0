import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/screens/just_play_screen.dart';
import 'package:sudoku_solver_2/widgets/shared/size_animated_route.dart';

/// Lives on the HomeScreen, navigating users to the JustPlayScreen
class JustPlayButtonWidget extends StatelessWidget {
  JustPlayButtonWidget({Key key}) : super(key: key);

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
            left: 50,
            right: 50,
          ),
          color: constants.pink,
          child: Text(
            constants.justPlayButtonText,
            style: constants.buttonTextStyle,
          ),
          onPressed: () async {
            await _navigateToJustPlayScreen(context);
            await constants.firebaseAnalytics.logEvent(name: 'button_just_play');
            await constants.playSound(constants.buttonPressedSound);
          },
        ),
      ),
    );
  }

  Future<void> _navigateToJustPlayScreen(BuildContext context) async {
    await Navigator.push(
      context,
      SizeAnimatedRoute(
        nextPage: JustPlayScreen(),
        routeSettings: RouteSettings(name: '/just-play'),
      ),
    );
  }
}
