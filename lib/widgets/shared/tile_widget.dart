import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/redux/actions.dart';

/// 1 of the 81 tiles that makes up a Sudoku
class TileWidget extends StatelessWidget {
  final TileKey tileKey;
  const TileWidget({@required this.tileKey, Key key}) : super(key: key);

  Key _createPropertyKey(TileState tileState) {
    String key = '$tileKey';
    key += ' - color:${_getTileColorString(tileState)}';
    key += ' - textColor:${(tileState.isInvalid) ? 'red' : 'black'}';
    key += ' - X:${tileState.isSelected && tileState.value != null}';
    return Key(key);
  }

  String _getTileColorString(TileState tileState) {
    if (tileState.isOriginalTile) {
      return 'grey';
    } else if (tileState.isSelected) {
      return 'green';
    } else {
      return 'white';
    }
  }

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, TileState>(
        key: Key(tileKey.toString()),
        distinct: true,
        converter: (Store<AppState> store) => store.state.tileStateMap[tileKey],
        builder: (BuildContext context, TileState tileState) {
          assert(tileState != null);
          return GestureDetector(
            onTap: () async {
              if (tileState.isOriginalTile) {
                return;
              }

              if (tileState.isSelected) {
                Redux.store.dispatch(TileDeselectedAction(tileState));
                Redux.store.dispatch(UpdateInvalidTilesAction());
                Redux.store.dispatch(UpdateGameStateAction(Redux.store.state.tileStateMap));
                Redux.store.dispatch(ApplyGameStateChangesAction(Redux.store.state.gameState));
              } else {
                await playSound(tileSelectedSound);
                Redux.store.dispatch(TileSelectedAction(tileState));
              }
            },
            child: Container(
              key: _createPropertyKey(tileState),
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: _determineTileColor(tileState),
                border: Border(
                  bottom: BorderSide(width: (tileState.row == 3 || tileState.row == 6) ? 3 : 0, color: black),
                  right: BorderSide(width: (tileState.col == 3 || tileState.col == 6) ? 3 : 0, color: black),
                ),
              ),
              child: Stack(
                textDirection: TextDirection.ltr,
                children: <Widget>[
                  // Displays the tile's value
                  Center(
                    child: Text(
                      (tileState.value == null) ? '' : '${tileState.value}',
                      style: TextStyle(
                        fontSize: tileFontSize,
                        fontFamily: fontStyleNumber,
                        fontWeight: FontWeight.w400,
                        color: (tileState.isInvalid) ? red : black,
                      ),
                      textDirection: TextDirection.ltr,
                      key: Key('${tileKey}_text'),
                    ),
                  ),

                  // Displays a red X in the corner if the value can be removed
                  if (tileState.isSelected && tileState.value != null)
                    const Text(
                      'X',
                      style: tileWithRemovableValueTextStyle,
                      textDirection: TextDirection.ltr,
                    )
                  else
                    Container(),
                ],
              ),
            ),
          );
        },
      );

  Color _determineTileColor(TileState tileState) {
    if (tileState.isOriginalTile) {
      return grey;
    } else if (tileState.isSelected) {
      return green;
    } else {
      return white;
    }
  }
}
