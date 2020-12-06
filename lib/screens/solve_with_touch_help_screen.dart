import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_text_widget.dart';

/// Shown when 'help' is selected from the drop down menu on SolveWithTouchScreen
class SolveWithTouchHelpScreen extends StatelessWidget {
  static final String _tip1SolveWithTouchScreen = '1. Touch a tile to select it';
  static final String _tip2SolveWithTouchScreen = '2. Touch the number you want to add to the tile';
  static final String _tip3SolveWithTouchScreen = '''3. Continue until the sudoku matches the 
  sudoku you want to solve''';
  static final String _tip4SolveWithTouchScreen = '4. Press SOLVE MY SUDOKU';
  static final String _tip5SolveWithTouchScreen = 'To remove the number from a tile, tap it twice';

  SolveWithTouchHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    my_values.firebaseAnalytics.setCurrentScreen(screenName: 'SolveWithTouchHelpScreen');

    Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithTouchHelpScreen));

    return Scaffold(
      backgroundColor: my_colors.pink,
      appBar: HelpScreenAppBar(AppBar()),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HelpScreenTextWidget(text: _tip1SolveWithTouchScreen),
            HelpScreenTextWidget(text: _tip2SolveWithTouchScreen),
            HelpScreenTextWidget(text: _tip3SolveWithTouchScreen),
            HelpScreenTextWidget(text: _tip4SolveWithTouchScreen),
            HelpScreenTextWidget(text: _tip5SolveWithTouchScreen),
          ],
        ),
      ),
    );
  }
}
