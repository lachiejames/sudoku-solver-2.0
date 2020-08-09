import 'package:sudoku_solver_2/state/tile_state.dart';

class TileSelectedAction {
  final TileState selectedTile;

  TileSelectedAction(this.selectedTile);
}

class TileDeselectedAction {
  final TileState deselectedTile;

  TileDeselectedAction(this.deselectedTile);
}
