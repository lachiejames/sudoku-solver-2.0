import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

final Reducer<CameraState> cameraStateReducer = combineReducers<CameraState>([
  TypedReducer<CameraState, TakePhotoAction>(_takePhotoReducer),
  TypedReducer<CameraState, VerifyPhotoCreatedSudokuAction>(_verifyPhotoReducer),
]);

CameraState _takePhotoReducer(CameraState cameraState, TakePhotoAction action) {
  print('_takePhotoReducer');

  cameraState.takePicture().then((_) => Redux.store.dispatch(VerifyPhotoCreatedSudokuAction()));
  return cameraState;
}

CameraState _verifyPhotoReducer(CameraState cameraState, VerifyPhotoCreatedSudokuAction action) {
  print('_verifyPhotoReducer');

  return cameraState;
}
