import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Shown when a game is completed on the JustPlayScreen
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
        return Visibility(
          visible: (gameState == GameState.solved),
          child: Container(
            alignment: Alignment.center,
            margin: my_styles.buttonMargins,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: RaisedButton(
                shape: my_styles.buttonShape,
                padding: my_styles.buttonPadding,
                color: my_colors.blue,
                child: Text(
                  my_strings.newGameButtonText,
                  style: my_styles.buttonTextStyle,
                ),
                onPressed: () {
                  Redux.store.dispatch(NewGameButtonPressedAction());
                  Redux.store.dispatch(LoadSudokuGameAction(Redux.store.state.gameNumber));
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
