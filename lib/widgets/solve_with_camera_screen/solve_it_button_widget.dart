import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

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
        print(gameState);
        return Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(
            left: 32,
            right: 32,
          ),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: RaisedButton(
              shape: MyStyles.buttonShape,
              padding: MyStyles.buttonPadding,
              color: MyColors.blue,
              child: Text(
                MyStrings.solveItButtonText,
                style: MyStyles.buttonTextStyle,
              ),
              onPressed: (gameState == GameState.IsSolving || gameState == GameState.InvalidTilesPresent)
                  ? null
                  : () async {
                      Redux.store.dispatch(StartSolvingSudokuAction());
                    },
            ),
          ),
        );
      },
    );
  }
}
