import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

class SolveMySudokuButtonWidget extends StatefulWidget {
  SolveMySudokuButtonWidget({Key key}) : super(key: key);

  @override
  _SolveMySudokuButtonWidgetState createState() =>
      _SolveMySudokuButtonWidgetState();
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
          margin: MyStyles.buttonMargins,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: MyStyles.buttonShape,
              padding: MyStyles.buttonPadding,
              color: (gameState == GameState.IsSolving)
                  ? MyColors.grey
                  : MyColors.blue,
              child: Text(
                MyStrings.solveMySudokuButtonText,
                style: MyStyles.buttonTextStyle,
              ),
              // Should be disabled while solving
              onPressed: (gameState == GameState.IsSolving ||
                      gameState == GameState.InvalidTilesPresent)
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
