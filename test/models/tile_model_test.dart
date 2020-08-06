import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/models/tile_model.dart';

void main() {
  TileModel tileModelWithoutValue;
  TileModel tileModelWithValue;

  setUp(() {
    tileModelWithoutValue = TileModel(null, row: 6, col: 9);
    tileModelWithValue = TileModel(5, row: 1, col: 3);
  });

  test('TileModel is correctly initialised', () {
    expect(tileModelWithoutValue, isNotNull);
    expect(tileModelWithoutValue.row, 6);
    expect(tileModelWithoutValue.col, 9);
    expect(tileModelWithoutValue.value, null);

    expect(tileModelWithValue, isNotNull);
    expect(tileModelWithValue.row, 1);
    expect(tileModelWithValue.col, 3);
    expect(tileModelWithValue.value, 5);
  });

  test('toString() returns expected string', () {
    expect(tileModelWithoutValue.toString(), 'TileModel(6, 9) value=null');
    expect(tileModelWithValue.toString(), 'TileModel(1, 3) value=5');
  });

  test('getSegment() returns correct segment', () {
    expect(tileModelWithoutValue.getSegment(), 6);
    expect(tileModelWithValue.getSegment(), 1);
  });

  test('setValue will update the value', () {
    expect(tileModelWithoutValue.value, null);
    tileModelWithoutValue.setValue(9);
    expect(tileModelWithoutValue.value, 9);

    expect(tileModelWithValue.value, 5);
    tileModelWithValue.setValue(1);
    expect(tileModelWithValue.value, 1);
  });
}
