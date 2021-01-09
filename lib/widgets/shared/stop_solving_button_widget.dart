import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Applies the solving algorithm to the Sudoku the user has entered
class StopSolvingSudokuButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        if (gameState != GameState.isSolving) {
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
                constants.stopSolvingButtonText,
                style: constants.buttonTextStyle,
              ),
              onPressed: () async {
                Redux.store.dispatch(StopSolvingSudokuAction());
                await constants.firebaseAnalytics.logEvent(name: 'button_solve_sudoku');
                await constants.solveSudokuButtonPressedTrace.incrementMetric('stop-solving-button-pressed', 1);
                await constants.playSound(constants.buttonPressedSound);
              },
            ),
          ),
        );
      },
    );
  }
}
