import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Applies the solving algorithm to the Sudoku the user has entered
class SolveSudokuButtonWidget extends StatelessWidget {
  final List<GameState> _gameStatesToBeActiveFor = <GameState>[
    GameState.photoProcessed,
    GameState.normal,
    GameState.invalidTilesPresent,
    GameState.solvingSudokuTimeoutError,
    GameState.solvingSudokuInvalidError,
  ];

  bool _cannotBeSolved(GameState gameState) => <GameState>[
        GameState.invalidTilesPresent,
        GameState.solvingSudokuInvalidError,
      ].contains(gameState);

  SolveSudokuButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, GameState>(
        distinct: true,
        converter: (Store<AppState> store) => store.state.gameState,
        builder: (BuildContext context, GameState gameState) {
          if (!_gameStatesToBeActiveFor.contains(gameState)) {
            return Container();
          }
          return Container(
            margin: gameState == GameState.photoProcessed
                ? const EdgeInsets.only(
                    top: 8,
                    bottom: 16,
                    left: 32,
                    right: 32,
                  )
                : buttonMargins,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  shape: buttonShape,
                  padding: buttonPadding,
                  color: blue,
                  onPressed: (_cannotBeSolved(gameState))
                      ? null
                      : () async {
                          await playSound(buttonPressedSound);
                          await logEvent('button_solve_sudoku');

                          await solveSudokuButtonPressedTrace.start();
                          Redux.store.dispatch(SolveSudokuAction());
                        },
                  child: const Text(
                    solveSudokuButtonText,
                    style: buttonTextStyle,
                  ),
                ),
              ),
            ),
          );
        },
      );
}
