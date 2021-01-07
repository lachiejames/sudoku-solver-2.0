import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Applies the solving algorithm to the Sudoku the user has entered
class SolveSudokuButtonWidget extends StatelessWidget {
  final List<GameState> _gameStatesToBeActiveFor = [
    GameState.photoProcessed,
    GameState.normal,
    GameState.invalidTilesPresent,
    GameState.solvingSudokuTimeoutError,
    GameState.solvingSudokuInvalidError,
  ];

  bool _cannotBeSolved(GameState gameState) {
    return [
      GameState.invalidTilesPresent,
      GameState.solvingSudokuInvalidError,
    ].contains(gameState);
  }

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
          margin: constants.buttonMargins,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: constants.buttonShape,
              padding: constants.buttonPadding,
              color: constants.blue,
              child: Text(
                constants.solveSudokuButtonText,
                style: constants.buttonTextStyle,
              ),
              onPressed: (this._cannotBeSolved(gameState))
                  ? null
                  : () async {
                      await constants.solveSudokuButtonPressedTrace.start();
                      Redux.store.dispatch(SolveSudokuAction());
                      await constants.firebaseAnalytics.logEvent(name: 'button_solve_sudoku');
                    },
            ),
          ),
        );
      },
    );
  }
}
