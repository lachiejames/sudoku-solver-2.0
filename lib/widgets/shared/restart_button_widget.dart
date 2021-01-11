import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

class RestartButtonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        if (gameState != GameState.solved) {
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
              color: constants.blue,
              child: Text(
                constants.restartButtonText,
                style: constants.buttonTextStyle,
              ),
              onPressed: () async {
                await constants.playSound(constants.buttonPressedSound);
                await constants.firebaseAnalytics.logEvent(name: 'button_restart');

                Redux.store.dispatch(RestartAction());
              },
            ),
          ),
        );
      },
    );
  }
}
