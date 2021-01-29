import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

/// Shown when the SolveWithCameraScreen is loaded
class StopProcessingPhotoButtonWidget extends StatelessWidget {
  const StopProcessingPhotoButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, GameState>(
        distinct: true,
        converter: (Store<AppState> store) => store.state.gameState,
        builder: (BuildContext context, GameState gameState) {
          if (gameState != GameState.processingPhoto) {
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
                color: red,
                onPressed: () async {
                  await playSound(buttonPressedSound);
                  await logEvent('button_take_photo');
                  await takePhotoButtonPressedTrace.incrementMetric('stop-constructing-button-pressed', 1);
                  Redux.store.dispatch(StopProcessingPhotoAction());
                  Redux.store.dispatch(ChangeScreenAction(ScreenState.solveWithCameraScreen));
                },
                child: const Text(
                  topTextStopConstructingSudoku,
                  style: buttonTextStyle,
                ),
              ),
            ),
          );
        },
      );
}
