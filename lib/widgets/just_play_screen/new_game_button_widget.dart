import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

class NewGameButtonWidget extends StatefulWidget {
  NewGameButtonWidget({Key key}) : super(key: key);

  @override
  _NewGameButtonWidgetState createState() => _NewGameButtonWidgetState();
}

class _NewGameButtonWidgetState extends State<NewGameButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        // Should only be visible when solved
        return Opacity(
          opacity: (gameState == GameState.solved) ? 1.0 : 0.0,
          child: Container(
            alignment: Alignment.center,
            margin: MyStyles.buttonMargins,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: RaisedButton(
                shape: MyStyles.buttonShape,
                padding: MyStyles.buttonPadding,
                color: MyColors.blue,
                child: Text(
                  MyStrings.newGameButtonText,
                  style: MyStyles.buttonTextStyle,
                ),
                onPressed: () {
                  if (gameState == GameState.solved) {
                    Redux.store.dispatch(NewGameButtonPressedAction());
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
