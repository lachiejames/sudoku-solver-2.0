import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/constants/my_styles.dart' as my_styles;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/solve_with_touch_screen/solve_with_touch_screen_drop_down_menu_widget.dart';

/// AppBar on the SolveWithTouchScreen
class SolveWithTouchScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Required so I can return preferredSize
  final AppBar appBar;
  SolveWithTouchScreenAppBar(this.appBar, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: my_colors.white),
      title: Text(
        my_strings.solveWithTouchScreenName,
        style: my_styles.appBarTextStyle,
        textDirection: TextDirection.ltr,
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 23),
          child: GestureDetector(
            child: SolveWithTouchScreenDropDownMenuWidget(),
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () async {
          Redux.store.dispatch(ChangeScreenAction(ScreenState.homeScreen));
          await Navigator.pop(context);
          await my_values.firebaseAnalytics.logEvent(name: 'button_back');
        },
        icon: (Platform.isAndroid) ? const Icon(Icons.arrow_back) : const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(this.appBar.preferredSize.height);
}
