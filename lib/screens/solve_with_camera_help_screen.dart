import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_text_widget.dart';

class SolveWithCameraHelpScreen extends StatelessWidget {
  SolveWithCameraHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.SolveWithCameraHelpScreen));

    return Scaffold(
      backgroundColor: MyColors.pink,
      appBar: HelpScreenAppBar(AppBar()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            HelpScreenTextWidget(text: MyStrings.tip1SolveWithCameraScreen),
            HelpScreenTextWidget(text: MyStrings.tip2SolveWithCameraScreen),
            HelpScreenTextWidget(text: MyStrings.tip3SolveWithCameraScreen),
            HelpScreenTextWidget(text: MyStrings.tip4SolveWithCameraScreen),
          ],
        ),
      ),
    );
  }
}
