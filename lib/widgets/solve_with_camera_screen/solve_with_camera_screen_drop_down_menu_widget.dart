import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/solve_with_camera_help_screen.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/widgets/shared/slide_animated_route.dart';

/// Drop down menu shown on the SolveWithCameraScreen
class SolveWithCameraScreenDropDownMenuWidget extends StatelessWidget {
  const SolveWithCameraScreenDropDownMenuWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DropdownButton<String>(
        icon: const Icon(
          Icons.more_vert,
          color: white,
        ),
        style: dropDownMenuTextStyle,
        items: _createDropdownMenuItems(),
        onChanged: (String value) async {
          await _performAction(value, context);
        },
      );

  List<DropdownMenuItem<String>> _createDropdownMenuItems() => <String>[
        dropDownMenuOption1,
        dropDownMenuOption2,
      ]
          .map(
            _createDropdownMenuItem,
          )
          .toList();

  DropdownMenuItem<String> _createDropdownMenuItem(String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          textDirection: TextDirection.ltr,
        ),
      );

  Future<void> _performAction(String value, BuildContext context) async {
    await playSound(buttonPressedSound);
    if (value == dropDownMenuOption1) {
      _restart();
    } else if (value == dropDownMenuOption2) {
      await _navigateToSolveWithTouchHelpScreen(context);
    }
  }

  void _restart() {
    if (Redux.store.state.gameState == GameState.isSolving) {
      Redux.store.dispatch(StopSolvingSudokuAction());
    }
    if (Redux.store.state.gameState == GameState.processingPhoto) {
      Redux.store.dispatch(StopProcessingPhotoAction());
    }
    Redux.store.dispatch(RestartAction());
  }

  Future<void> _navigateToSolveWithTouchHelpScreen(BuildContext context) async {
    await Navigator.push(
      context,
      SlideAnimatedRoute(
        nextPage: const SolveWithCameraHelpScreen(),
        routeSettings: const RouteSettings(name: '/solve-with-camera/help'),
      ),
    );
  }
}
