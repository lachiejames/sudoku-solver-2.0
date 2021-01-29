import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import '../constants/test_constants.dart';
void main() {
  group('TileState ->', () {
    TileState tileState;

    setUp(() {
      TestConstants.setMockMethodsForUnitTests();
      tileState = TileState(row: 6, col: 9);
    });

    test('initialised with correct values', () {
      expect(tileState, isNotNull);
      expect(tileState.row, 6);
      expect(tileState.col, 9);
      expect(tileState.value, null);
      expect(tileState.isSelected, false);
    });

    test('toString() returns expected string', () {
      expect(tileState.toString(), 'TileState(row=6, col=9, value=null, isSelected=false, isOriginalTile=false, isinvalid=false)');
    });

    test('getSegment() returns correct segment', () {
      expect(tileState.getSegment(), 6);
    });

    test('copyWith() returns a new object', () {
      TileState cloneTileState = tileState.copyWith(value: 5, isSelected: true);
      expect(tileState == cloneTileState, false);
      expect(cloneTileState.value, 5);
      expect(cloneTileState.isSelected, true);
    });
  });
}
