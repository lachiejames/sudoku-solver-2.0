import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_text_widget.dart';

/// Shown when 'help' is selected from the drop down menu on SolveWithTouchScreen
class SolveWithTouchHelpScreen extends StatelessWidget {
  SolveWithTouchHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithTouchHelpScreen));

    return Scaffold(
      backgroundColor: MyColors.pink,
      appBar: HelpScreenAppBar(AppBar()),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HelpScreenTextWidget(text: MyStrings.tip1SolveWithTouchScreen),
            HelpScreenTextWidget(text: MyStrings.tip2SolveWithTouchScreen),
            HelpScreenTextWidget(text: MyStrings.tip3SolveWithTouchScreen),
            HelpScreenTextWidget(text: MyStrings.tip4SolveWithTouchScreen),
            HelpScreenTextWidget(text: MyStrings.tip5SolveWithTouchScreen),
          ],
        ),
      ),
    );
  }
}
