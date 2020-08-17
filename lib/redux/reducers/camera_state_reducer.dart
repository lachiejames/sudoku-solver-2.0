import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

final Reducer<CameraState> cameraStateReducer = combineReducers<CameraState>([
  TypedReducer<CameraState, TakePhotoAction>(_takePhotoReducer),
]);

CameraState _takePhotoReducer(CameraState cameraState, TakePhotoAction action) {
  print('_takePhotoReducer');
  return cameraState;
}
