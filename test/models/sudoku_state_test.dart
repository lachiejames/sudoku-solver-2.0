import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/state/sudoku_state.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

import '../constants/test_constants.dart';

void main() {
  group('SudokuState', () {
    SudokuState sudokuState;

    setUp(() {
      sudokuState = SudokuState(tileStateMap: MyWidgets.initTileStateMap());
    });

    group('before example values added', () {
      test('toString() is correctly formatted', () {
        expect(sudokuState.toString(), TestConstants.emptySudokuString);
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
        expect(sudokuState.toString(), TestConstants.game1ValuesListString);
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

      test('addValueToTile() increases numValue, if replacing value with a different value', () {
        expect(sudokuState.numValues, 22);
        sudokuState.addValueToTile(7, sudokuState.getTileStateAt(1, 4));
        expect(sudokuState.numValues, 22);
      });

      test('addValueToTile() decreases numValue, if removing a value from a tile', () {
        expect(sudokuState.numValues, 22);
        sudokuState.addValueToTile(null, sudokuState.getTileStateAt(1, 4));
        expect(sudokuState.numValues, 21);
      });

      test('getTilesInRow() returns a list of tiles in the given row', () {
        List<TileState> tilesInRow = sudokuState.getTilesInRow(1);
        expect(tilesInRow.length, 9);
        expect(tilesInRow.toString(), TestConstants.game1TilesInRow1String);
      });

      test('getTilesInCol() returns a list of tiles in the given column', () {
        List<TileState> tilesInCol = sudokuState.getTilesInCol(3);
        expect(tilesInCol.length, 9);
        expect(tilesInCol.toString(), TestConstants.game1TilesInCol3String);
      });

      test('getTilesInSegment() returns a list of tiles in the given column', () {
        List<TileState> tilesInSegment = sudokuState.getTilesInSegment(2);
        expect(tilesInSegment.length, 9);
        expect(tilesInSegment.toString(), TestConstants.game1TilesInSegment2String);
      });

      test('getValuesInRow() returns a list of values in the given row', () {
        expect(sudokuState.getValuesInRow(1), [5, 4, 3, 9]);
        expect(sudokuState.getValuesInRow(5), [8, 9]);
        expect(sudokuState.getValuesInRow(9), [2, 4, 1, 7]);
      });

      test('getValuesInCol() returns a list of values in the given column', () {
        expect(sudokuState.getValuesInCol(1), [2]);
        expect(sudokuState.getValuesInCol(5), [4, 8, 1]);
        expect(sudokuState.getValuesInCol(9), [6, 4]);
      });

      test('getValuesInSegment() returns a list of values in the given segment', () {
        expect(sudokuState.getValuesInSegment(1), [7]);
        expect(sudokuState.getValuesInSegment(5), [9, 8, 4]);
        expect(sudokuState.getValuesInSegment(9), [4, 2, 7]);
      });

      test('getPossibleValuesAtTile() an empty list if the tile has a value', () {
        TileState tileState = sudokuState.getTileStateAt(3, 4);
        expect(tileState.value, 6);
        expect(sudokuState.getPossibleValuesAtTile(tileState), []);
      });

      test('getPossibleValuesAtTile() returns correct values allowed at a tile', () {
        TileState tileState = sudokuState.getTileStateAt(1, 1);
        expect(tileState.value, null);
        expect(sudokuState.getPossibleValuesAtTile(tileState), [1, 6, 8]);
      });

      test('allConstraintsSatisfied() returns false when identical values occupy the same row', () {
        sudokuState.addValueToTile(1, sudokuState.getTileStateAt(1, 1));
        sudokuState.addValueToTile(1, sudokuState.getTileStateAt(1, 3));
        expect(sudokuState.allConstraintsSatisfied(), false);
      });

      test('allConstraintsSatisfied() returns false when identical values occupy the same column', () {
        sudokuState.addValueToTile(1, sudokuState.getTileStateAt(1, 1));
        sudokuState.addValueToTile(1, sudokuState.getTileStateAt(3, 1));
        expect(sudokuState.allConstraintsSatisfied(), false);
      });

      test('allConstraintsSatisfied() returns false when identical values occupy the same segment', () {
        sudokuState.addValueToTile(1, sudokuState.getTileStateAt(1, 1));
        sudokuState.addValueToTile(1, sudokuState.getTileStateAt(3, 3));
        expect(sudokuState.allConstraintsSatisfied(), false);
      });

      test('allConstraintsSatisfied() returns true for a solved game', () {
        sudokuState = SudokuState(tileStateMap: MyWidgets.initTileStateMap());
        sudokuState.applyExampleValues(TestConstants.game2ValuesListSolved);
        expect(sudokuState.allConstraintsSatisfied(), true);
      });

      test('isFull() returns true when all tiles have a value', () {
        sudokuState = SudokuState(tileStateMap: MyWidgets.initTileStateMap());
        sudokuState.applyExampleValues(TestConstants.game2ValuesListSolved);
        expect(sudokuState.isFull(), true);
      });

      test('getNextUnassignedTile() returns a tile without a value, if possible', () {
        expect(sudokuState.getNextTileWithoutValue().toString(), 'TileState(row=1, col=1, value=null, isTapped=false)');
      });

      test('getNextUnassignedTile() returns null if the sudoku is complete', () {
        sudokuState = SudokuState(tileStateMap: MyWidgets.initTileStateMap());
        sudokuState.applyExampleValues(TestConstants.game2ValuesListSolved);
        expect(sudokuState.getNextTileWithoutValue(), null);
      });
    });
  });
}
