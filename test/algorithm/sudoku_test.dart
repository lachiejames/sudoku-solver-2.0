import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/algorithm/sudoku.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import '../constants/test_constants.dart';

void main() {
  group('sudoku ->', () {
    Sudoku sudoku;

    setUp(() {
      setMockMethodsForUnitTests();
      sudoku = Sudoku(tileStateMap: TileState.initTileStateMap());
    });

    group('before example values added ->', () {
      test('toString() is correctly formatted', () {
        expect(sudoku.toString(), emptySudokuString);
      });

      test('initTileMap() initialised with 81 tiles', () {
        expect(sudoku.tileStateMap.length, 81);
      });

      test('initTileMap() tiles are all valid', () {
        for (final TileState tileState in sudoku.tileStateMap.values.toList()) {
          expect(tileState, isNotNull);
          expect(1 <= tileState.row && tileState.row <= 9, true);
          expect(1 <= tileState.col && tileState.col <= 9, true);
          expect(tileState.value, isNull);
          expect(tileState.isSelected, false);
        }
      });
    });

    group('after example values added ->', () {
      setUp(() {
        sudoku.applyExampleValues(games[1]);
      });

      test('getTileStateAt() returns correct tile', () {
        expect(sudoku.getTileStateAt(6, 9).toString(),
            'TileState(row=6, col=9, value=null, isSelected=false, isOriginalTile=false, isinvalid=false)');
        expect(sudoku.getTileStateAt(9, 1).toString(),
            'TileState(row=9, col=1, value=2, isSelected=false, isOriginalTile=false, isinvalid=false)');
      });

      test('applyExampleValues() updates the state with the given values list', () {
        expect(sudoku.toString(), game1ValuesListString);
      });

      test('addValueToTile() adds the given value to the given tile', () {
        sudoku.addValueToTile(7, sudoku.getTileStateAt(6, 9));
        expect(sudoku.getTileStateAt(6, 9).toString(),
            'TileState(row=6, col=9, value=7, isSelected=false, isOriginalTile=false, isinvalid=false)');
      });

      test('addValueToTile() increases numValue, if replacing value with a different value', () {
        expect(sudoku.numValues, 22);
        sudoku.addValueToTile(7, sudoku.getTileStateAt(1, 4));
        expect(sudoku.numValues, 22);
      });

      test('addValueToTile() decreases numValue, if removing a value from a tile', () {
        expect(sudoku.numValues, 22);
        sudoku.addValueToTile(null, sudoku.getTileStateAt(1, 4));
        expect(sudoku.numValues, 21);
      });

      test('getTilesInRow() returns a list of tiles in the given row', () {
        final List<TileState> tilesInRow = sudoku.getTilesInRow(1);
        expect(tilesInRow.length, 9);
        expect(tilesInRow.toString(), game1TilesInRow1String);
      });

      test('getTilesInCol() returns a list of tiles in the given column', () {
        final List<TileState> tilesInCol = sudoku.getTilesInCol(3);
        expect(tilesInCol.length, 9);
        expect(tilesInCol.toString(), game1TilesInCol3String);
      });

      test('getTilesInSegment() returns a list of tiles in the given column', () {
        final List<TileState> tilesInSegment = sudoku.getTilesInSegment(2);
        expect(tilesInSegment.length, 9);
        expect(tilesInSegment.toString(), game1TilesInSegment2String);
      });

      test('getValuesInRow() returns a list of values in the given row', () {
        expect(sudoku.getValuesInRow(1), <int>[5, 4, 3, 9]);
        expect(sudoku.getValuesInRow(5), <int>[8, 9]);
        expect(sudoku.getValuesInRow(9), <int>[2, 4, 1, 7]);
      });

      test('getValuesInCol() returns a list of values in the given column', () {
        expect(sudoku.getValuesInCol(1), <int>[2]);
        expect(sudoku.getValuesInCol(5), <int>[4, 8, 1]);
        expect(sudoku.getValuesInCol(9), <int>[6, 4]);
      });

      test('getValuesInSegment() returns a list of values in the given segment', () {
        expect(sudoku.getValuesInSegment(1), <int>[7]);
        expect(sudoku.getValuesInSegment(5), <int>[9, 8, 4]);
        expect(sudoku.getValuesInSegment(9), <int>[4, 2, 7]);
      });

      test('getPossibleValuesAtTile() an empty list if the tile has a value', () {
        final TileState tileState = sudoku.getTileStateAt(3, 4);
        expect(tileState.value, 6);
        expect(sudoku.getPossibleValuesAtTile(tileState), <int>[]);
      });

      test('getPossibleValuesAtTile() returns correct values allowed at a tile', () {
        final TileState tileState = sudoku.getTileStateAt(1, 1);
        expect(tileState.value, null);
        expect(sudoku.getPossibleValuesAtTile(tileState), <int>[1, 6, 8]);
      });

      test('allConstraintsSatisfied() returns false when identical values occupy the same row', () {
        sudoku..addValueToTile(1, sudoku.getTileStateAt(1, 1))..addValueToTile(1, sudoku.getTileStateAt(1, 3));
        expect(sudoku.allConstraintsSatisfied(), false);
      });

      test('allConstraintsSatisfied() returns false when identical values occupy the same column', () {
        sudoku..addValueToTile(1, sudoku.getTileStateAt(1, 1))..addValueToTile(1, sudoku.getTileStateAt(3, 1));
        expect(sudoku.allConstraintsSatisfied(), false);
      });

      test('allConstraintsSatisfied() returns false when identical values occupy the same segment', () {
        sudoku..addValueToTile(1, sudoku.getTileStateAt(1, 1))..addValueToTile(1, sudoku.getTileStateAt(3, 3));
        expect(sudoku.allConstraintsSatisfied(), false);
      });

      test('allConstraintsSatisfied() returns true for a solved game', () {
        sudoku = Sudoku(tileStateMap: TileState.initTileStateMap())..applyExampleValues(game2ValuesListSolved);
        expect(sudoku.allConstraintsSatisfied(), true);
      });

      test('isFull() returns true when all tiles have a value', () {
        sudoku = Sudoku(tileStateMap: TileState.initTileStateMap())..applyExampleValues(game2ValuesListSolved);
        expect(sudoku.isFull(), true);
      });

      test('getNextUnassignedTile() returns a tile without a value, if possible', () {
        expect(sudoku.getNextTileWithoutValue().toString(),
            'TileState(row=1, col=1, value=null, isSelected=false, isOriginalTile=false, isinvalid=false)');
      });

      test('getNextUnassignedTile() returns null if the sudoku is complete', () {
        sudoku = Sudoku(tileStateMap: TileState.initTileStateMap())..applyExampleValues(game2ValuesListSolved);
        expect(sudoku.getNextTileWithoutValue(), null);
      });
    });
  });
}
