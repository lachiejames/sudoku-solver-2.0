import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/redux/actions.dart';

class TileWidget extends StatefulWidget {
  final TileKey tileKey;
  TileWidget({@required this.tileKey, Key key}) : super(key: key);

  @override
  _TileWidgetState createState() => _TileWidgetState(tileKey: this.tileKey);
}

class _TileWidgetState extends State<TileWidget> {
  final TileKey tileKey;
  _TileWidgetState({@required this.tileKey});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TileState>(
      distinct: true,
      converter: (store) => store.state.tileStateMap[this.tileKey],
      builder: (context, tileState) {
        assert(tileState != null);
        return GestureDetector(
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: _determineTileColor(tileState),
              border: Border(
                bottom: BorderSide(
                    width: (tileState.row == 3 || tileState.row == 6) ? 3 : 0,
                    color: MyColors.black),
                right: BorderSide(
                    width: (tileState.col == 3 || tileState.col == 6) ? 3 : 0,
                    color: MyColors.black),
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
                      fontSize: MyValues.tileFontSize,
                      fontFamily: MyStyles.fontStyleNumber,
                      fontWeight: FontWeight.w400,
                      color:
                          (tileState.isInvalid) ? MyColors.red : MyColors.black,
                    ),
                    textDirection: TextDirection.ltr,
                  ),
                ),

                // Displays a red X in the corner if the value can be removed
                (tileState.isSelected && tileState.value != null)
                    ? Text(
                        'X',
                        style: MyStyles.tileWithRemovableValueTextStyle,
                        textDirection: TextDirection.ltr,
                      )
                    : MyWidgets.getEmptyWidget(),
              ],
            ),
          ),
          onTap: () {
            if (tileState.isOriginalTile) {
              return;
            }

            if (tileState.isSelected) {
              Redux.store.dispatch(TileDeselectedAction(tileState));
            } else {
              Redux.store.dispatch(TileSelectedAction(tileState));
            }
            Redux.store.dispatch(CheckForInvalidTilesAction());
          },
        );
      },
    );
  }

  Color _determineTileColor(TileState tileState) {
    if (tileState.isOriginalTile) {
      return MyColors.grey;
    } else if (tileState.isSelected) {
      return MyColors.green;
    } else {
      return MyColors.white;
    }
  }
}
