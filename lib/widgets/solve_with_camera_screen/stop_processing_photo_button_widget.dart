import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

/// Shown when the SolveWithCameraScreen is loaded
class StopProcessingPhotoButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        if (gameState != GameState.processingPhoto) {
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
                color: constants.red,
                child: Text(
                  constants.topTextStopConstructingSudoku,
                  style: constants.buttonTextStyle,
                ),
                onPressed: () async {
                  await constants.playSound(constants.buttonPressedSound);
                  await constants.firebaseAnalytics.logEvent(name: 'button_take_photo');
                  await constants.takePhotoButtonPressedTrace.incrementMetric('stop-constructing-button-pressed', 1);
                  Redux.store.dispatch(StopProcessingPhotoAction());
                  Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithCameraScreen));
                }),
          ),
        );
      },
    );
  }
}
