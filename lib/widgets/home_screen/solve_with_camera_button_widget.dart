import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
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
      _getScaleTransitionRoute(
        SolveWithCameraScreen(),
        RouteSettings(name: '/solve-with-camera'),
      ),
    );
  }

  _getScaleTransitionRoute(Widget nextScreen, RouteSettings routeSettings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
      settings: routeSettings,
      transitionDuration: Duration(seconds: 5),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: animation.drive(
            Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: Curves.ease)),
          ),
          child: child,
        );
      },
    );
  }

  _getSlideTransitionRoute(Widget nextScreen, RouteSettings routeSettings) {
    return PageRouteBuilder(
      settings: routeSettings,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return nextScreen;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return ScaleTransition(
          scale: Tween<double>(begin: 1, end: 2).animate(animation),
          child: child,
        );
      },
    );
  }

  _getHeroTransitionRoute(Widget nextScreen, RouteSettings routeSettings) {
    return PageRouteBuilder(
      settings: routeSettings,
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return nextScreen;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return Align(
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1).animate(animation),
            child: child,
          ),
        );
      },
    );
  }
}
