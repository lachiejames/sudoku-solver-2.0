import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/solve_with_camera_screen/solve_with_camera_screen_drop_down_menu_widget.dart';

/// AppBar shown on the SolveWithCameraScreen
class SolveWithCameraScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Required so I can return preferredSize
  final AppBar appBar;
  const SolveWithCameraScreenAppBar(this.appBar, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AppBar(
        iconTheme: const IconThemeData(color: white),
        title: const Text(
          solveWithCameraScreenName,
          style: appBarTextStyle,
          textDirection: TextDirection.ltr,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 23),
            child: GestureDetector(
              child: const SolveWithCameraScreenDropDownMenuWidget(),
            ),
          ),
        ],
        leading: IconButton(
          onPressed: () async {
            await playSound(buttonPressedSound);
            await logEvent('button_back');
            Redux.store.dispatch(ChangeScreenAction(ScreenState.homeScreen));
            Navigator.pop(context);
          },
          icon: (Platform.isAndroid) ? const Icon(Icons.arrow_back) : const Icon(Icons.arrow_back_ios),
        ),
      );

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
