import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/widgets/shared/tile_widget.dart';

/// the 81 tiles that makes up a Sudoku
class SudokuWidget extends StatefulWidget {
  SudokuWidget({Key key}) : super(key: key);

  @override
  _SudokuWidgetState createState() => _SudokuWidgetState();
}

class _SudokuWidgetState extends State<SudokuWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      textDirection: TextDirection.ltr,
      children: <Widget>[
        Container(
          color: my_colors.white,
          margin: EdgeInsets.only(
            left: 27,
            right: 27,
          ),
          child: this.makeTable(),
        ),
        StoreConnector<AppState, GameState>(
          distinct: true,
          converter: (store) => store.state.gameState,
          builder: (context, gameState) {
            return (gameState == GameState.isSolving || gameState == GameState.processingPhoto)
                ? Container(
                    height: 290,
                    width: my_values.screenSize.width,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : Container();
          },
        ),
      ],
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
