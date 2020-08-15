import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';

class SolveWithTouchHelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: MyColors.pink,
      // // appBar: MyWidgets.makeAppBar(MyStrings.appBarTextHowToSolveScreen),
      // body: SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: <Widget>[
      //       MyWidgets.makeHowToText(MyStrings.step1TextHowToSolveScreen),
      //       MyWidgets.makeHowToText(MyStrings.step2TextHowToSolveScreen),
      //       MyWidgets.makeHowToText(MyStrings.step3TextHowToSolveScreen),
      //       MyWidgets.makeHowToText(MyStrings.tip1TextHowToSolveScreen),
      //       MyWidgets.makeHowToText(MyStrings.tip2TextHowToSolveScreen),
      //     ],
      //   ),
      // ),
    );
  }
}
