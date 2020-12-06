import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_text_widget.dart';

/// Shown when 'help' is selected from the drop down menu on SolveWithCameraScreen
class SolveWithCameraHelpScreen extends StatelessWidget {
  static final String _tip1SolveWithCameraScreen = '1. Align your sudoku with the camera';
  static final String _tip2SolveWithCameraScreen = '2. Press TAKE PHOTO';
  static final String _tip3SolveWithCameraScreen = '''3. Verify whether the generated sudoku 
  matches the sudoku you are trying to solve''';
  static final String _tip4SolveWithCameraScreen = '4. If it matches, press SOLVE MY SUDOKU';

  SolveWithCameraHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    my_values.firebaseAnalytics.setCurrentScreen(screenName: 'SolveWithCameraHelpScreen');

    Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithCameraHelpScreen));

    return Scaffold(
      backgroundColor: my_colors.pink,
      appBar: HelpScreenAppBar(AppBar()),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HelpScreenTextWidget(text: _tip1SolveWithCameraScreen),
            HelpScreenTextWidget(text: _tip2SolveWithCameraScreen),
            HelpScreenTextWidget(text: _tip3SolveWithCameraScreen),
            HelpScreenTextWidget(text: _tip4SolveWithCameraScreen),
          ],
        ),
      ),
    );
  }
}
