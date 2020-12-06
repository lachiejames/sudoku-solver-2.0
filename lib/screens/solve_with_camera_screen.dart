import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';
import 'package:sudoku_solver_2/widgets/shared/sudoku_widget.dart';
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
    @override
  void initState() {
    super.initState();
    my_values.firebaseAnalytics.setCurrentScreen(screenName: 'SolveWithCameraScreen');
  }

  Widget _makeTakingPhotoScreen(GameState gameState) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TopTextWidget(),
        CameraWidget(),
        TakePhotoButtonWidget(),
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
        SolveItButtonWidget(),
        RetakePhotoButtonWidget(),
        TakePhotoButtonWidget(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithCameraScreen));
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
                  : 
                  // SingleChildScrollView(
                  //     child: Column(
                  //       children: <Widget>[
                  //         Container(
                  //           child: Container(
                  //             margin: EdgeInsets.all(50),
                  //             width: 200,
                  //             height: 200,
                  //             child: fullImageGlobal != null ? Image.file(fullImageGlobal) : Container(),
                  //           ),
                  //         ),
                  //         Container(
                  //           child: Container(
                  //             margin: EdgeInsets.all(50),
                  //             width: 200,
                  //             height: 200,
                  //             child: croppedImageGlobal != null ? Image.file(croppedImageGlobal) : Container(),
                  //           ),
                  //         ),
                  //         Container(
                  //           child: Container(
                  //             margin: EdgeInsets.all(50),
                  //             width: 200,
                  //             height: 200,
                  //             child: sudokuImageGlobal != null ? Image.file(sudokuImageGlobal) : Container(),
                  //           ),
                  //         ),
                  //         Container(
                  //           child: Container(
                  //             margin: EdgeInsets.all(50),
                  //             width: 200,
                  //             height: 200,
                  //             child: tileImageGlobal != null ? Image.file(tileImageGlobal) : Container(),
                  //           ),
                  //         ),
                  //         RaisedButton(
                  //           child: Text('refresh'),
                  //           onPressed: () {
                  //             setState(() {});
                  //           },
                  //         )
                  //       ],
                  //     ),
                  //   )

              _makeVerifyPhotoScreen(gameState),
              ),
        );
      },
    );
  }
}
