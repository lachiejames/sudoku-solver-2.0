import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/state/sudoku_state.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

void main() {
  group('SudokuState', () {
    SudokuState sudokuState;

    setUp(() {
      sudokuState = SudokuState(tileStateMap: MyWidgets.initTileStateMap());
    });

    group('before example values added', () {
      test('toString() is correctly formatted', () {
        expect(sudokuState.toString(), MyGames.emptySudokuString);
      });

      test('initTileMap() initialised with 81 tiles', () {
        expect(sudokuState.tileStateMap.length, 81);
      });

      test('initTileMap() tiles are all valid', () {
        for (TileState tileState in sudokuState.tileStateMap.values.toList()) {
          expect(tileState, isNotNull);
          expect(1 <= tileState.row && tileState.row <= 9, true);
          expect(1 <= tileState.col && tileState.col <= 9, true);
          expect(tileState.value, isNull);
          expect(tileState.isTapped, false);
        }
      });
    });

    group('after example values added', () {
      setUp(() {
        sudokuState.applyExampleValues(MyGames.games[1]);
      });

      test('getTileStateAt() returns correct tile', () {
        expect(sudokuState.getTileStateAt(6, 9).toString(), 'TileState(row=6, col=9, value=null, isTapped=false)');
        expect(sudokuState.getTileStateAt(9, 1).toString(), 'TileState(row=9, col=1, value=2, isTapped=false)');
      });

      test('applyExampleValues() updates the state with the given values list', () {
        expect(sudokuState.toString(), MyGames.game1ValuesListString);
      });

      test('addValueToTile() provides tileStateMap with a copy of the tile', () {
        TileState tileState = sudokuState.getTileStateAt(6, 9);
        sudokuState.addValueToTile(7, tileState);
        TileState nextTileState = sudokuState.getTileStateAt(6, 9);
        expect(tileState == nextTileState, false);
      });

      test('addValueToTile() adds the given value to the given tile', () {
        sudokuState.addValueToTile(7, sudokuState.getTileStateAt(6, 9));
        expect(sudokuState.getTileStateAt(6, 9).toString(), 'TileState(row=6, col=9, value=7, isTapped=false)');
      });

      test('getTilesInRow() returns a list of tiles in the given row', () {
        List<TileState> tilesInRow = sudokuState.getTilesInRow(1);
        expect(tilesInRow.length, 9);
        expect(tilesInRow.toString(), MyGames.game1TilesInRow1String);
      });

      test('getTilesInCol() returns a list of tiles in the given column', () {
        List<TileState> tilesInCol = sudokuState.getTilesInCol(3);
        expect(tilesInCol.length, 9);
        expect(tilesInCol.toString(), MyGames.game1TilesInCol3String);
      });

      test('getTilesInSegment() returns a list of tiles in the given column', () {
        List<TileState> tilesInSegment = sudokuState.getTilesInSegment(2);
        expect(tilesInSegment.length, 9);
        expect(tilesInSegment.toString(), MyGames.game1TilesInSegment2String);
      });
    });
  });
}
