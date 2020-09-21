import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/just_play_screen/just_play_screen_drop_down_menu_widget.dart';

/// AppBar on the JustPlayScreen
class JustPlayScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Required so I can return preferredSize
  final AppBar appBar;
  JustPlayScreenAppBar(this.appBar, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: MyColors.white),
      title: Text(
        MyStrings.justPlayScreenName,
        style: MyStyles.appBarTextStyle,
        textDirection: TextDirection.ltr,
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 24),
          child: GestureDetector(
            child: JustPlayScreenDropDownMenuWidget(),
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () {
          Redux.store.dispatch(ChangeScreenAction(ScreenState.homeScreen));
          Navigator.pop(context);
        },
        icon:
            (Platform.isAndroid) ? const Icon(Icons.arrow_back) : const Icon(Icons.arrow_back_ios),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(this.appBar.preferredSize.height);
}
