import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/models/sudoku_model.dart';
import 'package:sudoku_solver_2/models/tile_model.dart';
import 'package:sudoku_solver_2/widgets/tile_widget.dart';

class SudokuWidget extends StatefulWidget {
  final SudokuModel sudokuModel;
  SudokuWidget({@required this.sudokuModel});
  @override
  State<StatefulWidget> createState() => SudokuWidgetState(sudokuModel: this.sudokuModel);
}

class SudokuWidgetState extends State<SudokuWidget> {
  final SudokuModel sudokuModel;
  SudokuWidgetState({@required this.sudokuModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(
        left: MyValues.screenWidth / 15,
        right: MyValues.screenWidth / 15,
      ),
      child: this.makeTable(),
    );
  }

  Table makeTable() {
    return Table(
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
    );
  }

  TableRow makeTableRow(int rowNum) {
    return TableRow(
      children: [
        this.makeTileCell(this.sudokuModel.getTileAt(rowNum, 1)),
        this.makeTileCell(this.sudokuModel.getTileAt(rowNum, 2)),
        this.makeTileCell(this.sudokuModel.getTileAt(rowNum, 3)),
        this.makeTileCell(this.sudokuModel.getTileAt(rowNum, 4)),
        this.makeTileCell(this.sudokuModel.getTileAt(rowNum, 5)),
        this.makeTileCell(this.sudokuModel.getTileAt(rowNum, 6)),
        this.makeTileCell(this.sudokuModel.getTileAt(rowNum, 7)),
        this.makeTileCell(this.sudokuModel.getTileAt(rowNum, 8)),
        this.makeTileCell(this.sudokuModel.getTileAt(rowNum, 9)),
      ],
    );
  }

  Widget makeTileCell(TileModel tileModel) {
    return TileWidget(tileModel: tileModel);
  }
}
