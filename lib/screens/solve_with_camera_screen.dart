import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/camera_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/solve_with_camera_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/take_photo_button_widget.dart';

class SolveWithCameraScreen extends StatefulWidget {
  SolveWithCameraScreen({Key key}) : super(key: key);

  @override
  _SolveWithCameraScreenState createState() => _SolveWithCameraScreenState();
}

class _SolveWithCameraScreenState extends State<SolveWithCameraScreen> {
  void initScreenSize(BuildContext context) {
    MyValues.screenHeight = MediaQuery.of(context).size.height;
    MyValues.screenWidth = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    this.initScreenSize(context);
    Redux.store.dispatch(ChangeScreenAction(ScreenState.SolveWithCameraScreen));
    print('screenHeight=${MyValues.screenHeight}'); // 722.6666666666666
    print('screenWidth=${MyValues.screenWidth}'); // 360.0

    MyValues.cameraWidth = MyValues.screenWidth - 2 * MyValues.pad;
    MyValues.cameraHeight = MyValues.cameraWidth;
    print('cameraWidth=${MyValues.cameraWidth}'); // 296.0
    print('cameraHeight=${MyValues.cameraHeight}'); // 296.0

    return Scaffold(
      appBar: SolveWithCameraScreenAppBar(AppBar()),
      backgroundColor: MyColors.pink,
      body: Stack(
        children: <Widget>[
          // Camera
          CameraWidget(),

          // topText and button
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TopTextWidget(),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: MyValues.verticalPadding, color: MyColors.transparent),
                      bottom: BorderSide(width: MyValues.verticalPadding, color: MyColors.transparent),
                      left: BorderSide(width: MyValues.horizontalPadding, color: MyColors.transparent),
                      right: BorderSide(width: MyValues.horizontalPadding, color: MyColors.transparent),
                    ),
                  ),
                ),
                TakePhotoButtonWidget(),
                RaisedButton(
                  child: Text('refresh'),
                  onPressed: () {
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
