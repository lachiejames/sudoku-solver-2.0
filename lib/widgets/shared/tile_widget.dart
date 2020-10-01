import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/redux/actions.dart';

/// 1 of the 81 tiles that makes up a Sudoku
class TileWidget extends StatefulWidget {
  final TileKey tileKey;
  TileWidget({@required this.tileKey, Key key}) : super(key: key);

  @override
  _TileWidgetState createState() => _TileWidgetState(tileKey: this.tileKey);
}

class _TileWidgetState extends State<TileWidget> {
  final TileKey tileKey;
  _TileWidgetState({@required this.tileKey});

  Key _createPropertyKey(TileState tileState) {
    String key = '${this.tileKey.toString()}';
    key += ' - color:${this._getTileColorString(tileState)}';
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
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TileState>(
      key: Key(this.tileKey.toString()),
      distinct: true,
      converter: (store) => store.state.tileStateMap[this.tileKey],
      builder: (context, tileState) {
        assert(tileState != null);
        return GestureDetector(
          child: Container(
            key: this._createPropertyKey(tileState),
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: _determineTileColor(tileState),
              border: Border(
                bottom: BorderSide(
                    width: (tileState.row == 3 || tileState.row == 6) ? 3 : 0,
                    color: my_colors.black),
                right: BorderSide(
                    width: (tileState.col == 3 || tileState.col == 6) ? 3 : 0,
                    color: my_colors.black),
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
                      fontSize: my_values.tileFontSize,
                      fontFamily: my_styles.fontStyleNumber,
                      fontWeight: FontWeight.w400,
                      color: (tileState.isInvalid) ? my_colors.red : my_colors.black,
                    ),
                    textDirection: TextDirection.ltr,
                    key: Key('${this.tileKey.toString()}_text'),
                  ),
                ),

                // Displays a red X in the corner if the value can be removed
                (tileState.isSelected && tileState.value != null)
                    ? Text(
                        'X',
                        style: my_styles.tileWithRemovableValueTextStyle,
                        textDirection: TextDirection.ltr,
                      )
                    : Container(),
              ],
            ),
          ),
          onTap: () {
            if (tileState.isOriginalTile) {
              return;
            }

            if (tileState.isSelected) {
              Redux.store.dispatch(TileDeselectedAction(tileState));
              Redux.store.dispatch(UpdateInvalidTilesAction());
              Redux.store.dispatch(UpdateGameStateAction(Redux.store.state.tileStateMap));
              Redux.store.dispatch(ApplyGameStateChangesAction(Redux.store.state.gameState));
            } else {
              Redux.store.dispatch(TileSelectedAction(tileState));
            }
          },
        );
      },
    );
  }

  Color _determineTileColor(TileState tileState) {
    if (tileState.isOriginalTile) {
      return my_colors.grey;
    } else if (tileState.isSelected) {
      return my_colors.green;
    } else {
      return my_colors.white;
    }
  }
}
