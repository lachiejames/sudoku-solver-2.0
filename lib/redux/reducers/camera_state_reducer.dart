import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

final Reducer<CameraState> cameraStateReducer = combineReducers<CameraState>([
  TypedReducer<CameraState, TakePhotoAction>(_takePhotoReducer),
  TypedReducer<CameraState, VerifyPhotoCreatedSudokuAction>(_verifyPhotoReducer),
]);

CameraState _takePhotoReducer(CameraState cameraState, TakePhotoAction action) {
  cameraState
      .takePicture()
      .then((_) => cameraState.getSudokuFromImage())
      .then((constructedSudoku) => Redux.store.dispatch(VerifyPhotoCreatedSudokuAction(constructedSudoku)));
  return cameraState;
}

CameraState _verifyPhotoReducer(CameraState cameraState, VerifyPhotoCreatedSudokuAction action) {
  print('_verifyPhotoReducer');

  return cameraState;
}
