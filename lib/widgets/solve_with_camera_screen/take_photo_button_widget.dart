import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
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
          margin: constants.buttonMargins,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: constants.buttonShape,
              padding: constants.buttonPadding,
              color: constants.blue,
              child: Text(
                constants.takePhotoButtonText,
                style: constants.buttonTextStyle,
              ),
              onPressed: () async {
                await constants.playSound(constants.buttonPressedSound);
                await constants.firebaseAnalytics.logEvent(name: 'button_take_photo');
                await constants.takePhotoButtonPressedTrace.start();

                Redux.store.dispatch(
                  SetCameraStateProperties(
                    screenSize: MediaQuery.of(context).size,
                  ),
                );
                File imageFile = await Redux.store.state.cameraState.getImageFileFromCamera();
                Redux.store.dispatch(TakePhotoAction(imageFile));
              },
            ),
          ),
        );
      },
    );
  }
}
