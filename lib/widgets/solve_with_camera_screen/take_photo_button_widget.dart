import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Shown when the SolveWithCameraScreen is loaded
class TakePhotoButtonWidget extends StatelessWidget {
  const TakePhotoButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, GameState>(
        distinct: true,
        converter: (Store<AppState> store) => store.state.gameState,
        builder: (BuildContext context, GameState gameState) {
          if (gameState != GameState.takingPhoto) {
            return Container();
          }
          return Container(
            alignment: Alignment.center,
            margin: buttonMargins,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: RaisedButton(
                shape: buttonShape,
                padding: buttonPadding,
                color: blue,
                onPressed: () async {
                  await playSound(buttonPressedSound);
                  await logEvent('button_take_photo');
                  await takePhotoButtonPressedTrace.start();

                  Redux.store.dispatch(
                    SetCameraStateProperties(
                      screenSize: MediaQuery.of(context).size,
                    ),
                  );
                  final File imageFile = await Redux.store.state.cameraState.getImageFileFromCamera();
                  Redux.store.dispatch(TakePhotoAction(imageFile));
                },
                child: const Text(
                  takePhotoButtonText,
                  style: buttonTextStyle,
                ),
              ),
            ),
          );
        },
      );
}
