import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/solve_with_touch_help_screen.dart';
import 'package:sudoku_solver_2/state/game_state.dart';

/// drop ddown menu on the SolveWithTouchScreen
class SolveWithTouchScreenDropDownMenuWidget extends StatelessWidget {
  SolveWithTouchScreenDropDownMenuWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: my_colors.white,
      ),
      style: my_styles.dropDownMenuTextStyle,
      items: _createDropdownMenuItems(),
      onChanged: (value) {
        this._performAction(value, context);
      },
    );
  }

  List<DropdownMenuItem<String>> _createDropdownMenuItems() {
    return <String>[
      my_strings.dropDownMenuOption1,
      my_strings.dropDownMenuOption2,
    ].map(
      (String value) {
        return this._createDropdownMenuItem(value);
      },
    ).toList();
  }

  DropdownMenuItem<String> _createDropdownMenuItem(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        textDirection: TextDirection.ltr,
      ),
    );
  }

  void _performAction(String value, BuildContext context) {
    if (value == my_strings.dropDownMenuOption1) {
      _restart();
    } else if (value == my_strings.dropDownMenuOption2) {
      _navigateToSolveWithTouchHelpScreen(context);
    }
  }

  void _restart() {
    if (Redux.store.state.gameState == GameState.isSolving) {
      Redux.store.dispatch(StopSolvingSudokuAction());
    }
    Redux.store.dispatch(RestartAction());
  }

  void _navigateToSolveWithTouchHelpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SolveWithTouchHelpScreen(),
        settings: RouteSettings(name: '/solve-with-touch/help'),
      ),
    );
  }
}
