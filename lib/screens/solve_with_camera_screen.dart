import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/sudoku_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/camera_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/retake_photo_button_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/solve_with_camera_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/take_photo_button_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/solve_it_button_widget.dart';

class SolveWithCameraScreen extends StatefulWidget {
  SolveWithCameraScreen({Key key}) : super(key: key);

  @override
  _SolveWithCameraScreenState createState() => _SolveWithCameraScreenState();
}

class _SolveWithCameraScreenState extends State<SolveWithCameraScreen> {
  void initScreenSizeProperties(BuildContext context) {
    // Set values required for SolveWithCameraScreen
    MyValues.screenHeight = MediaQuery.of(context).size.height;
    MyValues.screenWidth = MediaQuery.of(context).size.width;
    MyValues.cameraWidth = MyValues.screenWidth - 2 * MyValues.pad;
    MyValues.cameraHeight = MyValues.cameraWidth;
  }

  @override
  Widget build(BuildContext context) {
    this.initScreenSizeProperties(context);
    Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithCameraScreen));
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        return Scaffold(
          appBar: SolveWithCameraScreenAppBar(AppBar()),
          backgroundColor: MyColors.pink,
          body: SingleChildScrollView(
            child: (gameState == GameState.photoProcessed ||
                    gameState == GameState.isSolving ||
                    gameState == GameState.solved)
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TopTextWidget(),
                      SudokuWidget(),
                      RetakePhotoButtonWidget(),
                      SolveItButtonWidget(),
                    ],
                  )
                : Stack(
                    children: <Widget>[
                      // Camera
                      CameraWidget(),

                      // topText and button
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          TopTextWidget(),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    width: MyValues.verticalPadding, color: MyColors.transparent),
                                bottom: BorderSide(
                                    width: MyValues.verticalPadding, color: MyColors.transparent),
                              ),
                            ),
                          ),
                          TakePhotoButtonWidget(),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
