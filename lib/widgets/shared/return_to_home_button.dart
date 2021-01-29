import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

class ReturnToHomeButtonWidget extends StatelessWidget {
  final List<GameState> _gameStatesToBeActiveFor = <GameState>[
    GameState.cameraNotLoadedError,
    GameState.processingPhotoError,
  ];

  ReturnToHomeButtonWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, GameState>(
        distinct: true,
        converter: (Store<AppState> store) => store.state.gameState,
        builder: (BuildContext context, GameState gameState) {
          if (!_gameStatesToBeActiveFor.contains(gameState)) {
            return Container();
          }
          return Container(
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
                  await logEvent('button_return_to_home');

                  Redux.store.dispatch(ReturnToHomeAction());
                  Navigator.pop(context);
                },
                child: const Text(
                  returnToHomeText,
                  style: buttonTextStyle,
                ),
              ),
            ),
          );
        },
      );
}
