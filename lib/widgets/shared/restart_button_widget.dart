import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

class RestartButtonWidget extends StatelessWidget {
  const RestartButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, GameState>(
        distinct: true,
        converter: (Store<AppState> store) => store.state.gameState,
        builder: (BuildContext context, GameState gameState) {
          if (gameState != GameState.solved) {
            return Container();
          }
          return Container(
            margin: buttonMargins,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  shape: buttonShape,
                  padding: buttonPadding,
                  color: blue,
                  onPressed: () async {
                    await playSound(buttonPressedSound);
                    await logEvent('button_restart');

                    Redux.store.dispatch(RestartAction());
                  },
                  child: const Text(
                    restartButtonText,
                    style: buttonTextStyle,
                  ),
                ),
              ),
            ),
          );
        },
      );
}
