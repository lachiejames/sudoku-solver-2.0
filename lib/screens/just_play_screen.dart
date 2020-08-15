import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/widgets/just_play_screen/just_play_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/number_bar_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_touch_screen/solve_my_sudoku_button_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_touch_screen/solve_with_touch_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/sudoku_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';

class JustPlayScreen extends StatefulWidget {
  @override
  _JustPlayScreenState createState() => _JustPlayScreenState();
}

class _JustPlayScreenState extends State<JustPlayScreen> {
  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(LoadPlayScreenWithSudokuAction());
    return Scaffold(
      appBar: JustPlayScreenAppBar(AppBar()),
      backgroundColor: MyColors.pink,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TopTextWidget(),
            NumberBarWidget(),
            SudokuWidget(),
            SolveMySudokuButtonWidget(),
          ],
        ),
      ),
    );
  }
}
