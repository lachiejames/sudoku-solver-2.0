import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/just_play_help_screen.dart';

class JustPlayScreenDropDownMenuWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: MyColors.white,
      ),
      style: MyStyles.dropDownMenuTextStyle,
      items: _createDropdownMenuItems(),
      onChanged: (value) {
        this._performAction(value, context);
      },
    );
  }

  List<DropdownMenuItem<String>> _createDropdownMenuItems() {
    return <String>[
      MyStrings.dropDownMenuItemRestart,
      MyStrings.dropDownMenuItemHowToPlay,
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
    if (value == MyStrings.dropDownMenuItemRestart) {
      _restart();
    } else if (value == MyStrings.dropDownMenuItemHowToPlay) {
      _navigateToJustPlayHelpScreen(context);
    }
  }

  void _restart() {
    Redux.store.dispatch(RestartAction());
  }

  void _navigateToJustPlayHelpScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JustPlayHelpScreen(),
      ),
    );
  }
}