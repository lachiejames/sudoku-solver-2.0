import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_text_widget.dart';

/// Shown when 'help' is selected from the drop down menu on JustPlayScreen
class JustPlayHelpScreen extends StatelessWidget {
  static const String _tip1JustPlayScreen = '1. Touch a tile to select it';
  static const String _tip2JustPlayScreen = '2. Touch the number you want to add to the tile';
  static const String _tip3JustPlayScreen = '3. Continue until the Sudoku is solved';
  static const String _tip4JustPlayScreen = 'To remove the number from a tile, tap it twice';
  static const String _tip5JustPlayScreen =
      'To solve the Sudoku, add numbers to all tiles in the Sudoku such each number from 1-9 occurs exactly once in each row, column, and segment';

  const JustPlayHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.justPlayHelpScreen));

    return Scaffold(
      backgroundColor: pink,
      body: SingleChildScrollView(
        child: Column(
          children: const <Widget>[
            HelpScreenTextWidget(text: _tip1JustPlayScreen),
            HelpScreenTextWidget(text: _tip2JustPlayScreen),
            HelpScreenTextWidget(text: _tip3JustPlayScreen),
            HelpScreenTextWidget(text: _tip4JustPlayScreen),
            HelpScreenTextWidget(text: _tip5JustPlayScreen),
            HelpScreenTextWidget(text: ''),
          ],
        ),
      ),
      appBar: HelpScreenAppBar(AppBar()),
    );
  }
}
