import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/solve_sudoku_button_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/sudoku_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/camera_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/retake_photo_button_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/solve_with_camera_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/take_photo_button_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/restart_button_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/return_to_home_button.dart';
import 'package:sudoku_solver_2/widgets/shared/stop_solving_button_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/stop_processing_photo_button_widget.dart';

/// Shown when 'camera' is selected from the HomeScreen
class SolveWithCameraScreen extends StatefulWidget {
  const SolveWithCameraScreen({Key key}) : super(key: key);

  @override
  _SolveWithCameraScreenState createState() => _SolveWithCameraScreenState();
}

class _SolveWithCameraScreenState extends State<SolveWithCameraScreen> {
  @override
  void initState() {
    super.initState();
    showNewBannerAd();
  }

  @override
  void dispose() {
    disposeBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithCameraScreen));

    return Scaffold(
      appBar: SolveWithCameraScreenAppBar(AppBar()),
      backgroundColor: pink,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const TopTextWidget(),
            const CameraWidget(),
            SudokuWidget(),
            const TakePhotoButtonWidget(),
            SolveSudokuButtonWidget(),
            RetakePhotoButtonWidget(),
            const RestartButtonWidget(),
            ReturnToHomeButtonWidget(),
            const StopSolvingSudokuButtonWidget(),
            const StopProcessingPhotoButtonWidget(),
          ],
        ),
      ),
    );
  }
}
