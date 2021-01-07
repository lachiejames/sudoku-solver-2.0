import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Shown when the user has taken a photo, but wants to take another
class RetakePhotoButtonWidget extends StatelessWidget {
  final List<GameState> _gameStatesToBeActiveFor = [
    GameState.photoProcessed,
    GameState.invalidTilesPresent,
    GameState.processingPhotoError,
    GameState.solvingSudokuTimeoutError,
    GameState.solvingSudokuInvalidError,
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        if (!_gameStatesToBeActiveFor.contains(gameState)) {
          return Container();
        }

        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(0),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: constants.buttonShape,
              padding: constants.buttonPadding,
              color: constants.blue,
              child: Text(
                constants.retakePhotoButtonText,
                style: constants.buttonTextStyle,
              ),
              onPressed: () async {
                Redux.store.dispatch(RetakePhotoAction());
                await constants.firebaseAnalytics.logEvent(name: 'button_retake_photo');
              },
            ),
          ),
        );
      },
    );
  }
}
