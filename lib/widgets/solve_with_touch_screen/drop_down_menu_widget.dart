import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';

class SolveWithTouchScreenDropDownMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SolveWithTouchScreenDropDownMenuState();
}

class SolveWithTouchScreenDropDownMenuState extends State<SolveWithTouchScreenDropDownMenu> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: MyColors.white,
      ),
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      items: <String>[
        'Restart',
        MyStrings.appBarTextHowToSolveScreen,
      ].map(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              textDirection: TextDirection.ltr,
            ),
          );
        },
      ).toList(),
      onChanged: (value) {
        if (value == 'Restart') {
          restart();
        } else if (value == MyStrings.appBarTextHowToSolveScreen) {
          navigateToHowToSolveScreen(context);
        }
      },
    );
  }

  void restart() {}

  void navigateToHowToSolveScreen(BuildContext context) {}
}
