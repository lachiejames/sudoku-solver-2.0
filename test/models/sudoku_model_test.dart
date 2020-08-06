import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_games.dart';
import 'package:sudoku_solver_2/models/sudoku_model.dart';
import 'package:sudoku_solver_2/models/tile_model.dart';

void main() {
  SudokuModel sudokuModel;

  setUp(() {
    sudokuModel = SudokuModel();
  });

  test('toString() is correctly formatted', () {
    expect(sudokuModel.toString(), MyGames.emptySudokuString);
  });

  test('initTileMap - initialised with 81 tiles', () {
    expect(sudokuModel.tileModelMap.length, 81);
  });

  test('initTileMap - tiles are all valid', () {
    for (TileModel tileModel in sudokuModel.tileModelMap.values.toList()) {
      expect(tileModel, isNotNull);
      expect(1 <= tileModel.row && tileModel.row <= 9, true);
      expect(1 <= tileModel.col && tileModel.col <= 9, true);
      expect(tileModel.value, isNull);
    }
  });
}
