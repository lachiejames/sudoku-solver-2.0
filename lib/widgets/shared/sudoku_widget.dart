import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/widgets/shared/tile_widget.dart';

class SudokuWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SudokuWidgetState();
}

class SudokuWidgetState extends State<SudokuWidget> {
  SudokuWidgetState();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameState>(
      distinct: true,
      converter: (store) => store.state.gameState,
      builder: (context, gameState) {
        return Stack(
          textDirection: TextDirection.ltr,
          children: <Widget>[
            Container(
              color: MyColors.white,
              margin: EdgeInsets.only(
                left: MyValues.screenWidth / 15,
                right: MyValues.screenWidth / 15,
              ),
              child: this.makeTable(),
            ),
            (gameState == GameState.IsSolving) ? MyWidgets.makeProgressIndicator() : MyWidgets.getEmptyWidget(),
          ],
        );
      },
    );
  }

  Widget makeTable() {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Table(
        border: TableBorder.all(),
        children: [
          makeTableRow(1),
          makeTableRow(2),
          makeTableRow(3),
          makeTableRow(4),
          makeTableRow(5),
          makeTableRow(6),
          makeTableRow(7),
          makeTableRow(8),
          makeTableRow(9),
        ],
      ),
    );
  }

  TableRow makeTableRow(int rowNum) {
    return TableRow(
      children: [
        this.makeTileCell(TileKey(row: rowNum, col: 1)),
        this.makeTileCell(TileKey(row: rowNum, col: 2)),
        this.makeTileCell(TileKey(row: rowNum, col: 3)),
        this.makeTileCell(TileKey(row: rowNum, col: 4)),
        this.makeTileCell(TileKey(row: rowNum, col: 5)),
        this.makeTileCell(TileKey(row: rowNum, col: 6)),
        this.makeTileCell(TileKey(row: rowNum, col: 7)),
        this.makeTileCell(TileKey(row: rowNum, col: 8)),
        this.makeTileCell(TileKey(row: rowNum, col: 9)),
      ],
    );
  }

  Widget makeTileCell(TileKey tileKey) {
    return TileWidget(tileKey: tileKey);
  }
}
