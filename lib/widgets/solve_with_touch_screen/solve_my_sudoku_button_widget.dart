import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
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
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        return Container(
          alignment: Alignment.center,
          margin: my_styles.buttonMargins,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: my_styles.buttonShape,
              padding: my_styles.buttonPadding,
              color: (gameState == GameState.isSolving) ? my_colors.grey : my_colors.blue,
              child: Text(
                my_strings.solveMySudokuButtonText,
                style: my_styles.buttonTextStyle,
              ),
              // Should be disabled while solving
              onPressed:
                  (gameState == GameState.isSolving || gameState == GameState.invalidTilesPresent)
                      ? null
                      : () {
                          Redux.store.dispatch(SolveSudokuAction());
                        },
            ),
          ),
        );
      },
    );
  }
}
