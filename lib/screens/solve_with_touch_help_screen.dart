import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_text_widget.dart';

/// Shown when 'help' is selected from the drop down menu on SolveWithTouchScreen
class SolveWithTouchHelpScreen extends StatelessWidget {
  static const String _tip1SolveWithTouchScreen = '1. Touch a tile to select it';
  static const String _tip2SolveWithTouchScreen = '2. Touch the number you want to add to the tile';
  static const String _tip3SolveWithTouchScreen = '3. Continue until the sudoku matches the sudoku you want to solve';
  static const String _tip4SolveWithTouchScreen = '4. Press SOLVE SUDOKU';
  static const String _tip5SolveWithTouchScreen = 'To remove the number from a tile, tap it twice';

  const SolveWithTouchHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithTouchHelpScreen));

    return Scaffold(
      backgroundColor: pink,
      appBar: HelpScreenAppBar(AppBar()),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            HelpScreenTextWidget(text: _tip1SolveWithTouchScreen),
            HelpScreenTextWidget(text: _tip2SolveWithTouchScreen),
            HelpScreenTextWidget(text: _tip3SolveWithTouchScreen),
            HelpScreenTextWidget(text: _tip4SolveWithTouchScreen),
            HelpScreenTextWidget(text: _tip5SolveWithTouchScreen),
            HelpScreenTextWidget(text: ''),
          ],
        ),
      ),
    );
  }
}
