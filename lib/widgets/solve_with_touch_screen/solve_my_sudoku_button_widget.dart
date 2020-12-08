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
class SolveMySudokuButtonWidget extends StatefulWidget {
  SolveMySudokuButtonWidget({Key key}) : super(key: key);

  @override
  _SolveMySudokuButtonWidgetState createState() => _SolveMySudokuButtonWidgetState();
}

class _SolveMySudokuButtonWidgetState extends State<SolveMySudokuButtonWidget> {
  Key _createPropertyKey(GameState gameState) {
    String key = 'text:${this._determineText(gameState)}';
    key += ' - color:${this._determineColorString(gameState)}';
    key += ' - tappable:${(gameState == GameState.invalidTilesPresent) ? 'false' : 'true'}';
    return Key(key);
  }

  String _determineColorString(GameState gameState) {
    switch (gameState) {
      case GameState.isSolving:
        return 'red';
      case GameState.invalidTilesPresent:
        return 'grey';
      default:
        return 'blue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        return Container(
          key: this._createPropertyKey(gameState),
          alignment: Alignment.center,
          margin: my_styles.buttonMargins,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: my_styles.buttonShape,
              padding: my_styles.buttonPadding,
              color: _determineColor(gameState),
              child: Text(
                this._determineText(gameState),
                style: my_styles.buttonTextStyle,
              ),
              onPressed: () async {
                if (gameState == GameState.invalidTilesPresent) {
                  return null;
                }

                await _determineAction(gameState);
                await my_values.firebaseAnalytics.logEvent(name: 'button_solve_my_sudoku');
              },
            ),
          ),
        );
      },
    );
  }

  Color _determineColor(GameState gameState) {
    switch (gameState) {
      case GameState.isSolving:
        return my_colors.red;
      case GameState.invalidTilesPresent:
        return my_colors.grey;
      default:
        return my_colors.blue;
    }
  }

  String _determineText(GameState gameState) {
    switch (gameState) {
      case GameState.isSolving:
        return my_strings.stopSolvingButtonText;
      case GameState.solved:
        return my_strings.restartButtonText;
      default:
        return my_strings.solveMySudokuButtonText;
    }
  }

  Future<void> _determineAction(GameState gameState) async {
    switch (gameState) {
      case GameState.isSolving:
        await my_values.solveMySudokuButtonPressedTrace.incrementMetric('stop-solving-button-pressed', 1);
        Redux.store.dispatch(StopSolvingSudokuAction());
        break;
      case GameState.solved:
        Redux.store.dispatch(RestartAction());
        break;
      default:
        await my_values.solveMySudokuButtonPressedTrace.start();
        Redux.store.dispatch(SolveSudokuAction());
    }
  }
}
