import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/state/camera_state.dart';

/// Contains all state reducers used by CameraState
final Reducer<CameraState> cameraStateReducer =
    combineReducers<CameraState>(<CameraState Function(CameraState, dynamic)>[
  TypedReducer<CameraState, CameraReadyAction>(_cameraReadyReducer),
  TypedReducer<CameraState, SetCameraStateProperties>(_setCameraStatePropertiesReducer),
]);

CameraState _cameraReadyReducer(CameraState cameraState, CameraReadyAction action) =>
    cameraState.copyWith(cameraController: action.cameraController);

CameraState _setCameraStatePropertiesReducer(CameraState cameraState, SetCameraStateProperties action) =>
    cameraState.copyWith(
      screenSize: action.screenSize,
      cameraWidgetBounds: action.cameraWidgetBounds,
    );
