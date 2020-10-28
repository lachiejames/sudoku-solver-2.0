import 'package:async/async.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

/// Contains all state reducers used by CameraState
final Reducer<CameraState> cameraStateReducer = combineReducers<CameraState>([
  TypedReducer<CameraState, CameraReadyAction>(_cameraReadyReducer),
  TypedReducer<CameraState, TakePhotoAction>(_takePhotoReducer),
]);

CameraState _cameraReadyReducer(CameraState cameraState, CameraReadyAction action) {
  return cameraState.copyWith(cameraController: action.cameraController);
}

CancelableOperation cancellableOperation;
CameraState _takePhotoReducer(CameraState cameraState, TakePhotoAction action) {
  cancellableOperation = CancelableOperation.fromFuture(
    cameraState.getSudokuFromCamera()
  );

  cancellableOperation.asStream().listen(
    (sudoku) {
      print('hmm');
      Redux.store.dispatch(PhotoProcessedAction(sudoku));
    },
  );
  return cameraState;
}
