import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

final Reducer<CameraState> cameraStateReducer = combineReducers<CameraState>([
  TypedReducer<CameraState, StartProcessingPhotoAction>(_processingPhotoReducer),
]);


CameraState _processingPhotoReducer(CameraState cameraState, StartProcessingPhotoAction action) {
  // This makes the function not pure unfortunately
  cameraState.takePicture().then((pickedImageFile) {
    cameraState.getSudokuFromImage(pickedImageFile).then((sudoku) {
      assert(sudoku.tileStateMap.length == 81);
      Redux.store.dispatch(
        PhotoProcessedAction(sudoku),
      );
    });
  });

  return cameraState.copyWith();
}