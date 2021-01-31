import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

/// Contains a number from 1-9 for the user to select
class NumberWidget extends StatelessWidget {
  final int number;
  const NumberWidget({this.number, Key key}) : super(key: key);

  Key _createPropertyKey(NumberState numberState) {
    String key = 'Number($number)';
    key += ' - color:${(numberState.isActive) ? 'green' : 'white'}';
    return Key(key);
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, NumberState>(
        key: Key('Number($number)'),
        distinct: true,
        converter: (Store<AppState> store) => store.state.numberStateList[number - 1],
        builder: (BuildContext context, NumberState numberState) {
          assert(numberState.number != null);
          return GestureDetector(
            onTap: () async {
              if (numberState.isActive) {
                Redux.store.dispatch(NumberPressedAction(numberState));
                Redux.store.dispatch(UpdateInvalidTilesAction());
                Redux.store.dispatch(UpdateGameStateAction(Redux.store.state.tileStateMap));
                Redux.store.dispatch(ApplyGameStateChangesAction(Redux.store.state.gameState));

                // If this action solved the game on Just Play Screen
                if (Redux.store.state.screenState == ScreenState.justPlayScreen &&
                    Redux.store.state.gameState == GameState.solved) {
                  await playSound(gameSolvedSound);
                }
              }
            },
            child: Container(
              key: _createPropertyKey(numberState),
              height: 36,
              width: 36,
              margin: const EdgeInsets.only(
                top: 36,
                bottom: 36,
                left: 4,
                right: 4,
              ),
              decoration: ShapeDecoration(
                color: (numberState.isActive) ? green : white,
                shape: const CircleBorder(),
              ),
              child: Center(
                child: Text(
                  '${numberState.number}',
                  style: const TextStyle(
                    fontSize: numberFontSize,
                    fontFamily: fontStyleNumber,
                    fontWeight: FontWeight.w400,
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ),
            ),
          );
        },
      );
}
