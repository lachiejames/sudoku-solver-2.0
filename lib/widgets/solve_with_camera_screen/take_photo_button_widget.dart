import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Shown when the SolveWithCameraScreen is loaded
class TakePhotoButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        if (gameState != GameState.takingPhoto) {
          return Container();
        }
        return Container(
          alignment: Alignment.center,
          margin: my_styles.buttonMargins,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: my_styles.buttonShape,
              padding: my_styles.buttonPadding,
              color: my_colors.blue,
              child: Text(
                my_strings.takePhotoButtonText,
                style: my_styles.buttonTextStyle,
              ),
              onPressed: () async {
                await my_values.takePhotoButtonPressedTrace.start();

                Redux.store.dispatch(
                  SetCameraStateProperties(
                    screenSize: MediaQuery.of(context).size,
                  ),
                );
                File imageFile = await Redux.store.state.cameraState.getImageFileFromCamera();
                Redux.store.dispatch(TakePhotoAction(imageFile));
                await my_values.firebaseAnalytics.logEvent(name: 'button_take_photo');
              },
            ),
          ),
        );
      },
    );
  }
}
