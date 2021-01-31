import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/home_screen/just_play_button_widget.dart';
import 'package:sudoku_solver_2/widgets/home_screen/solve_with_camera_button_widget.dart';
import 'package:sudoku_solver_2/widgets/home_screen/solve_with_touch_button_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';

/// Shown when the app starts
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.homeScreen));
    
    return Scaffold(
      backgroundColor: blue,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              TopTextWidget(),
              SolveWithCameraButtonWidget(),
              SolveWithTouchButtonWidget(),
              JustPlayButtonWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
