import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

class JustPlayHelpScreen extends StatelessWidget {
  JustPlayHelpScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.JustPlayHelpScreen));

    return Scaffold(
      backgroundColor: MyColors.pink,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyWidgets.makeHowToText(MyStrings.step1TextHowToPlayScreen),
            MyWidgets.makeHowToText(MyStrings.step2TextHowToPlayScreen),
            MyWidgets.makeHowToText(MyStrings.step3TextHowToPlayScreen),
            MyWidgets.makeHowToText(MyStrings.tip1TextHowToPlayScreen),
            MyWidgets.makeHowToText(MyStrings.tip2TextHowToPlayScreen),
          ],
        ),
      ),
      appBar: MyWidgets.makeAppBar(MyStrings.appBarTextHowToPlayScreen),
    );
  }
}
