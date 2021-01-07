import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
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
      iconTheme: IconThemeData(color: constants.white),
      title: Text(
        constants.solveWithTouchScreenName,
        style: constants.appBarTextStyle,
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
          await constants.firebaseAnalytics.logEvent(name: 'button_back');
        },
        icon: (Platform.isAndroid) ? const Icon(Icons.arrow_back) : const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(this.appBar.preferredSize.height);
}
