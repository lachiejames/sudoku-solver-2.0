import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/shared/sudoku_widget.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/camera_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/retake_photo_button_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/solve_it_button_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/solve_with_camera_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/take_photo_button_widget.dart';

/// Shown when 'camera' is selected from the HomeScreen
class SolveWithCameraScreen extends StatefulWidget {
  SolveWithCameraScreen({Key key}) : super(key: key);

  @override
  _SolveWithCameraScreenState createState() => _SolveWithCameraScreenState();
}

class _SolveWithCameraScreenState extends State<SolveWithCameraScreen> {
  void initScreenSizeProperties(BuildContext context) {
    // Set values required for SolveWithCameraScreen
    my_values.screenHeight = MediaQuery.of(context).size.height;
    my_values.screenWidth = MediaQuery.of(context).size.width;
    my_values.cameraWidth = my_values.screenWidth - 2 * my_values.pad;
    my_values.cameraHeight = my_values.cameraWidth;

    my_values.verticalPadding = (my_values.screenHeight - my_values.cameraHeight) / 2;
    my_values.horizontalPadding = my_values.pad;
  }

  Widget _makeTakingPhotoScreen(GameState gameState) {
    return Stack(
      children: <Widget>[
        Container(
          color: my_colors.white,
          height: my_values.screenHeight,
          width: my_values.screenWidth,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),

        // Camera
        CameraWidget(),

        // Border
        Container(
          height: my_values.screenHeight,
          width: my_values.screenWidth,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: my_values.verticalPadding, color: my_colors.pink),
              bottom: BorderSide(width: my_values.verticalPadding, color: my_colors.pink),
              left: BorderSide(width: my_values.horizontalPadding, color: my_colors.pink),
              right: BorderSide(width: my_values.horizontalPadding, color: my_colors.pink),
            ),
          ),
        ),

        // Everything else
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TopTextWidget(),
            Container(
              height: my_values.cameraHeight + 2*my_values.pad,
            ),
            TakePhotoButtonWidget(),
          ],
        ),
      ],
    );
  }

  Widget _makeVerifyPhotoScreen(GameState gameState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TopTextWidget(),
        SudokuWidget(),
        // (cameraImage!=null) ? Image.file(croppedImageFile) : Container(),
        SolveItButtonWidget(),
        RetakePhotoButtonWidget(),
        TakePhotoButtonWidget(),
      ],
    );
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
          backgroundColor: my_colors.pink,
          body: SingleChildScrollView(
            child: (gameState == GameState.takingPhoto)
                ? _makeTakingPhotoScreen(gameState)
                : _makeVerifyPhotoScreen(gameState),
          ),
        );
      },
    );
  }
}
