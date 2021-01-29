import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// Shown when a game is completed on the JustPlayScreen
class NewGameButtonWidget extends StatelessWidget {
  const NewGameButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, GameState>(
        distinct: true,
        converter: (Store<AppState> store) => store.state.gameState,
        builder: (BuildContext context, GameState gameState) => Visibility(
          visible: gameState == GameState.solved,
          child: Container(
            alignment: Alignment.center,
            margin: buttonMargins,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: RaisedButton(
                shape: buttonShape,
                padding: buttonPadding,
                color: blue,
                onPressed: () async {
                  await playSound(buttonPressedSound);
                  Redux.store.dispatch(NewGameButtonPressedAction());
                  final int nextGameNumber = Redux.store.state.gameNumber;
                  await Redux.sharedPreferences.setInt(gameNumberSharedPrefsKey, nextGameNumber);
                  await logEvent('button_new_game');
                },
                child: const Text(
                  newGameButtonText,
                  style: buttonTextStyle,
                ),
              ),
            ),
          ),
        ),
      );
}
