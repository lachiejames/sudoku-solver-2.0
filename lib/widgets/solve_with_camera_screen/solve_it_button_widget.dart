import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Shown when the user has taken a photo, and wants to solve the corresponding Sudoku
class SolveItButtonWidget extends StatefulWidget {
  SolveItButtonWidget({Key key}) : super(key: key);

  @override
  _SolveItButtonWidgetState createState() => _SolveItButtonWidgetState();
}

class _SolveItButtonWidgetState extends State<SolveItButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            left: 32,
            right: 32,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: my_styles.buttonShape,
              padding: my_styles.buttonPadding,
              color: my_colors.blue,
              child: Text(
                my_strings.solveItButtonText,
                style: my_styles.buttonTextStyle,
              ),
              onPressed:
                  (gameState == GameState.isSolving || gameState == GameState.invalidTilesPresent)
                      ? null
                      : () async {
                          Redux.store.dispatch(SolveSudokuAction());
                        },
            ),
          ),
        );
      },
    );
  }
}
