import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Shown when the user has taken a photo, but wants to take another
class RetakePhotoButtonWidget extends StatelessWidget {
  final List<GameState> _gameStatesToBeActiveFor = <GameState>[
    GameState.photoProcessed,
    GameState.invalidTilesPresent,
    GameState.processingPhotoError,
    GameState.solvingSudokuTimeoutError,
    GameState.solvingSudokuInvalidError,
  ];

  RetakePhotoButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, GameState>(
        distinct: true,
        converter: (Store<AppState> store) => store.state.gameState,
        builder: (BuildContext context, GameState gameState) {
          if (!_gameStatesToBeActiveFor.contains(gameState)) {
            return Container();
          }

          return Container(
            margin: const EdgeInsets.only(
              left: 32,
              right: 32,
            ),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  shape: buttonShape,
                  padding: buttonPadding,
                  color: blue,
                  onPressed: () async {
                    await playSound(buttonPressedSound);
                    await logEvent('button_retake_photo');
                    Redux.store.dispatch(RetakePhotoAction());
                  },
                  child: const Text(
                    retakePhotoButtonText,
                    style: buttonTextStyle,
                  ),
                ),
              ),
            ),
          );
        },
      );
}
