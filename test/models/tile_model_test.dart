import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

void main() {
  TileState tileStateWithoutValue;
  TileState tileStateWithValue;

  setUp(() {
    tileStateWithoutValue = TileState(row: 6, col: 9, value: null);
    tileStateWithValue = TileState(row: 1, col: 3, value: 5);
  });

  test('TileState is correctly initialised', () {
    expect(tileStateWithoutValue, isNotNull);
    expect(tileStateWithoutValue.row, 6);
    expect(tileStateWithoutValue.col, 9);
    expect(tileStateWithoutValue.value, null);

    expect(tileStateWithValue, isNotNull);
    expect(tileStateWithValue.row, 1);
    expect(tileStateWithValue.col, 3);
    expect(tileStateWithValue.value, 5);
  });

  test('toString() returns expected string', () {
    expect(tileStateWithoutValue.toString(), 'TileState(6, 9) value=null');
    expect(tileStateWithValue.toString(), 'TileState(1, 3) value=5');
  });

  test('getSegment() returns correct segment', () {
    expect(tileStateWithoutValue.getSegment(), 6);
    expect(tileStateWithValue.getSegment(), 1);
  });
}
