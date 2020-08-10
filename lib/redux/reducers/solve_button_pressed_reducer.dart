import 'dart:collection';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';

AppState solveButtonPressedReducer(AppState appState, SolveButtonPressedAction action) {
  final HashMap<TileKey, TileState> newTileStateMap = HashMap.from(appState.tileStateMap);

  return appState.copyWith(
    tileStateMap: newTileStateMap,
  );
}


// sudoku cspState;
// bool backtracking(sudoku sudoku) {
//   if (sudoku.isComplete() || timeElapsed > MyValues.maxSolveTime) {
//     return true;
//   }

//   TileState tile = sudoku.getNextUnassignedTile();

//   for (int value in sudoku.getPossibleValuesAtTile(tile)) {
//     cspState.addValueToTile(value, tile);

//     if (cspState.allConstraintsSatisfied()) {
//       if (backtracking(cspState)) {
//         return true;
//       }
//     }
//     cspState.addValueToTile(null, tile);
//   }

//   return false;
// }

// sudoku solveSudoku(sudoku cs) {
//   startTime = DateTime.now().millisecondsSinceEpoch;
//   cspState = cs;
//   backtracking(cs);
//   return cs;
// }

// solveWithCompute(sudoku cs) async {
//   sudoku solvedSudoku = await compute(solveSudoku, cs);
//   return solvedSudoku;
// }