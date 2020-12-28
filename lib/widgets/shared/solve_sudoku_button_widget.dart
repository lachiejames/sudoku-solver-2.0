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
          margin: my_styles.buttonMargins,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: my_styles.buttonShape,
              padding: my_styles.buttonPadding,
              color: my_colors.blue,
              child: Text(
                my_strings.solveSudokuButtonText,
                style: my_styles.buttonTextStyle,
              ),
              onPressed: (this._cannotBeSolved(gameState))
                  ? null
                  : () async {
                      await my_values.solveSudokuButtonPressedTrace.start();
                      Redux.store.dispatch(SolveSudokuAction());
                      await my_values.firebaseAnalytics.logEvent(name: 'button_solve_sudoku');
                    },
            ),
          ),
        );
      },
    );
  }
}
