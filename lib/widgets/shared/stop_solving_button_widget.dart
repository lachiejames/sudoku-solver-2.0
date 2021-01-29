import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Applies the solving algorithm to the Sudoku the user has entered
class StopSolvingSudokuButtonWidget extends StatelessWidget {
  const StopSolvingSudokuButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, GameState>(
        distinct: true,
        converter: (Store<AppState> store) => store.state.gameState,
        builder: (BuildContext context, GameState gameState) {
          if (gameState != GameState.isSolving) {
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
                  await logEvent('button_solve_sudoku');
                  await solveSudokuButtonPressedTrace.incrementMetric('stop-solving-button-pressed', 1);
                  Redux.store.dispatch(StopSolvingSudokuAction());
                },
                child: const Text(
                  stopSolvingButtonText,
                  style: buttonTextStyle,
                ),
              ),
            ),
          );
        },
      );
}
