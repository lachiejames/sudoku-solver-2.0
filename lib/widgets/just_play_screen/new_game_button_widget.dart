import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Shown when a game is completed on the JustPlayScreen
class NewGameButtonWidget extends StatelessWidget {
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
            margin: constants.buttonMargins,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: RaisedButton(
                shape: constants.buttonShape,
                padding: constants.buttonPadding,
                color: constants.blue,
                child: Text(
                  constants.newGameButtonText,
                  style: constants.buttonTextStyle,
                ),
                onPressed: () async {
                  Redux.store.dispatch(NewGameButtonPressedAction());

                  int nextGameNumber = Redux.store.state.gameNumber;
                  await Redux.sharedPreferences.setInt(constants.gameNumberSharedPrefsKey, nextGameNumber);

                  await constants.firebaseAnalytics.logEvent(name: 'button_new_game');
                  await constants.playSound(constants.buttonPressedSound);
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
