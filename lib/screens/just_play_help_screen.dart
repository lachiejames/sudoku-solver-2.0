import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/help_screen_text_widget.dart';

class JustPlayHelpScreen extends StatelessWidget {
  JustPlayHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.JustPlayHelpScreen));

    return Scaffold(
      backgroundColor: MyColors.pink,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            HelpScreenTextWidget(text: MyStrings.tip1JustPlayScreen),
            HelpScreenTextWidget(text: MyStrings.tip2JustPlayScreen),
            HelpScreenTextWidget(text: MyStrings.tip3JustPlayScreen),
            HelpScreenTextWidget(text: MyStrings.tip4JustPlayScreen),
            HelpScreenTextWidget(text: MyStrings.tip5JustPlayScreen),
          ],
        ),
      ),
      appBar: HelpScreenAppBar(AppBar()),
    );
  }
}
