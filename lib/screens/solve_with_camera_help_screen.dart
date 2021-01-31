import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_text_widget.dart';

/// Shown when 'help' is selected from the drop down menu on SolveWithCameraScreen
class SolveWithCameraHelpScreen extends StatelessWidget {
  static const String _tip1SolveWithCameraScreen = '1. Align your Sudoku with the camera';
  static const String _tip2SolveWithCameraScreen = '2. Press TAKE PHOTO';
  static const String _tip3SolveWithCameraScreen =
      '3. Verify whether the generated Sudoku matches the Sudoku you are trying to solve';
  static const String _tip4SolveWithCameraScreen = '4. If it matches, press SOLVE SUDOKU';

  const SolveWithCameraHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithCameraHelpScreen));

    return Scaffold(
      backgroundColor: pink,
      appBar: HelpScreenAppBar(AppBar()),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            HelpScreenTextWidget(text: _tip1SolveWithCameraScreen),
            HelpScreenTextWidget(text: _tip2SolveWithCameraScreen),
            HelpScreenTextWidget(text: _tip3SolveWithCameraScreen),
            HelpScreenTextWidget(text: _tip4SolveWithCameraScreen),
            HelpScreenTextWidget(text: ''),
          ],
        ),
      ),
    );
  }
}
