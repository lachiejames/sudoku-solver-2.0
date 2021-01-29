import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/number_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';

/// Contains a number from 1-9 for the user to select
class NumberWidget extends StatelessWidget {
  final int number;
  NumberWidget({this.number, Key key}) : super(key: key);

  Key _createPropertyKey(NumberState numberState) {
    String key = 'Number(${this.number})';
    key += ' - color:${(numberState.isActive) ? 'green' : 'white'}';
    return Key(key);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NumberState>(
      key: Key('Number(${this.number})'),
      distinct: true,
      converter: (store) => store.state.numberStateList[this.number - 1],
      builder: (context, numberState) {
        assert(numberState.number != null);
        return GestureDetector(
          child: Container(
            key: this._createPropertyKey(numberState),
            height: 36,
            width: 36,
            margin: EdgeInsets.only(
              top: 36,
              bottom: 36,
              left: 4,
              right: 4,
            ),
            decoration: ShapeDecoration(
              color: (numberState.isActive) ? constants.green : constants.white,
              shape: CircleBorder(),
            ),
            child: Center(
              child: Text(
                '${numberState.number}',
                style: TextStyle(
                  fontSize: constants.numberFontSize,
                  fontFamily: constants.fontStyleNumber,
                  fontWeight: FontWeight.w400,
                ),
                textDirection: TextDirection.ltr,
              ),
            ),
          ),
          onTap: () async {
            if (numberState.isActive) {
              await constants.playSound(constants.tileDeselectedSound);
              Redux.store.dispatch(NumberPressedAction(numberState));
              Redux.store.dispatch(UpdateInvalidTilesAction());
              Redux.store.dispatch(UpdateGameStateAction(Redux.store.state.tileStateMap));
              Redux.store.dispatch(ApplyGameStateChangesAction(Redux.store.state.gameState));

              // If this action solved the game on Just Play Screen
              if (Redux.store.state.screenState == ScreenState.justPlayScreen &&
                  Redux.store.state.gameState == GameState.solved) {
                await constants.playSound(constants.gameSolvedSound);
              }
            }
          },
        );
      },
    );
  }
}
