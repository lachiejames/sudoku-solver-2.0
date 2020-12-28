import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/number_bar_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/restart_button_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/solve_sudoku_button_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/stop_solving_button_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_touch_screen/solve_with_touch_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/sudoku_widget.dart';
import 'package:sudoku_solver_2/constants/my_ad_helper.dart' as my_ad_helper;
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';

/// Shown when 'touch' is selected from the HomeScreen
class SolveWithTouchScreen extends StatefulWidget {
  SolveWithTouchScreen({Key key}) : super(key: key);

  @override
  _SolveWithTouchScreenState createState() => _SolveWithTouchScreenState();
}

class _SolveWithTouchScreenState extends State<SolveWithTouchScreen> {
  @override
  void initState() {
    super.initState();
    my_ad_helper.showNewBannerAd();
  }

  @override
  void dispose() {
    my_ad_helper.disposeBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithTouchScreen));

    return Scaffold(
      appBar: SolveWithTouchScreenAppBar(AppBar()),
      backgroundColor: my_colors.pink,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopTextWidget(),
            NumberBarWidget(),
            SudokuWidget(),
            SolveSudokuButtonWidget(),
            StopSolvingSudokuButtonWidget(),
            RestartButtonWidget(),
          ],
        ),
      ),
    );
  }
}
