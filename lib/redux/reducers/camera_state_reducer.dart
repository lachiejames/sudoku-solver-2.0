import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

final Reducer<CameraState> cameraStateReducer = combineReducers<CameraState>([
  TypedReducer<CameraState, ProcessPhotoAction>(_processPhotoReducer),
]);

CameraState _processPhotoReducer(CameraState cameraState, ProcessPhotoAction action) {
cameraState.getSudokuFromCamera(action.cameraController);
  return cameraState;
}
