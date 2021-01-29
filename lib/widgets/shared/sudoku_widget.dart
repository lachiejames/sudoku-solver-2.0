import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/widgets/shared/tile_widget.dart';

/// the 81 tiles that makes up a Sudoku
class SudokuWidget extends StatelessWidget {
  final List<GameState> _gameStatesToBeInactiveFor = <GameState>[
    GameState.cameraNotLoadedError,
    GameState.takingPhoto,
  ];

  SudokuWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => StoreConnector<AppState, GameState>(
        distinct: true,
        converter: (Store<AppState> store) => store.state.gameState,
        builder: (BuildContext context, GameState gameState) {
          if (_gameStatesToBeInactiveFor.contains(gameState)) {
            return Container();
          }
          return Stack(
            textDirection: TextDirection.ltr,
            children: <Widget>[
              Container(
                color: white,
                margin: const EdgeInsets.only(
                  left: 27,
                  right: 27,
                ),
                child: makeTable(),
              ),
              if (gameState == GameState.isSolving || gameState == GameState.processingPhoto)
                Container(
                  height: 290,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              else
                Container()
            ],
          );
        },
      );

  Widget makeTable() => Directionality(
        textDirection: TextDirection.ltr,
        child: Table(
          border: TableBorder.all(),
          children: <TableRow>[
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

  TableRow makeTableRow(int rowNum) => TableRow(
        children: <Widget>[
          makeTileCell(TileKey(row: rowNum, col: 1)),
          makeTileCell(TileKey(row: rowNum, col: 2)),
          makeTileCell(TileKey(row: rowNum, col: 3)),
          makeTileCell(TileKey(row: rowNum, col: 4)),
          makeTileCell(TileKey(row: rowNum, col: 5)),
          makeTileCell(TileKey(row: rowNum, col: 6)),
          makeTileCell(TileKey(row: rowNum, col: 7)),
          makeTileCell(TileKey(row: rowNum, col: 8)),
          makeTileCell(TileKey(row: rowNum, col: 9)),
        ],
      );

  Widget makeTileCell(TileKey tileKey) => TileWidget(tileKey: tileKey);
}
