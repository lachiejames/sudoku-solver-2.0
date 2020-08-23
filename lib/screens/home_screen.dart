import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/home_screen/just_play_button_widget.dart';
import 'package:sudoku_solver_2/widgets/home_screen/solve_with_camera_button_widget.dart';
import 'package:sudoku_solver_2/widgets/home_screen/solve_with_touch_button_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.HomeScreen));
    return Scaffold(
      backgroundColor: MyColors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TopTextWidget(),
            SolveWithCameraButtonWidget(),
            SolveWithTouchButtonWidget(),
            JustPlayButtonWidget(),
          ],
        ),
      ),
    );
  }
}
