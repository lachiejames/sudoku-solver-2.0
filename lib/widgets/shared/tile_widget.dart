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
  TileWidget({@required this.tileKey});
  @override
  State<StatefulWidget> createState() => TileWidgetState(tileKey: this.tileKey);
}

class TileWidgetState extends State<TileWidget> {
  final TileKey tileKey;
  TileWidgetState({@required this.tileKey});

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
              color: (tileState.isTapped) ? MyColors.green : MyColors.white,
              border: Border(
                bottom: BorderSide(width: (tileState.row == 3 || tileState.row == 6) ? 3 : 0, color: MyColors.black),
                right: BorderSide(width: (tileState.col == 3 || tileState.col == 6) ? 3 : 0, color: MyColors.black),
              ),
            ),
            child: Stack(
              children: <Widget>[
                // Has a grey background if the tile should not be removable
                (tileState.isOriginalTile)
                    ? Container(
                        color: MyColors.grey,
                      )
                    : MyWidgets.getEmptyWidget(),

                // Displays the tile's value
                Center(
                  child: Text(
                    (tileState.value == null) ? '' : '${tileState.value}',
                    style: MyStyles.tileTextStyle,
                    textDirection: TextDirection.ltr,
                  ),
                ),

                // Displays a red X in the corner if the value can be removed
                (tileState.isTapped && tileState.value != null)
                    ? Text(
                        'X',
                        style: MyStyles.tileWithRemovableValueTextStyle,
                      )
                    : MyWidgets.getEmptyWidget(),
              ],
            ),
          ),
          onTap: () {
            if (tileState.isTapped && tileState.value == null) {
              Redux.store.dispatch(TileDeselectedAction(tileState));
            } else if (tileState.isTapped && tileState.value != null) {
              Redux.store.dispatch(RemoveValueFromTileAction(tileState));
            } else {
              Redux.store.dispatch(TileSelectedAction(tileState));
            }
          },
        );
      },
    );
  }
}
