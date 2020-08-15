import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/solve_with_touch_screen.dart';

class SolveWithTouchScreenDropDownMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: MyColors.white,
      ),
      style: MyStyles.dropDownMenuTextStyle,
      items: createDropdownMenuItems(),
      onChanged: (value) {
        this.performAction(value, context);
      },
    );
  }

  List<DropdownMenuItem<String>> createDropdownMenuItems() {
    return <String>[
      MyStrings.dropDownMenuItemRestart,
      MyStrings.dropDownMenuItemHowToSolve,
    ].map(
      (String value) {
        return this.createDropdownMenuItem(value);
      },
    ).toList();
  }

  DropdownMenuItem<String> createDropdownMenuItem(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        textDirection: TextDirection.ltr,
      ),
    );
  }

  void performAction(String value, BuildContext context) {
    if (value == MyStrings.dropDownMenuItemRestart) {
      restart();
    } else if (value == MyStrings.dropDownMenuItemHowToSolve) {
      navigateToSolveWithTouchHelpScreen(context);
    }
  }

  void restart() {
    Redux.store.dispatch(RestartAction());
  }

  void navigateToSolveWithTouchHelpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SolveWithTouchScreen(),
      ),
    );
  }
}
