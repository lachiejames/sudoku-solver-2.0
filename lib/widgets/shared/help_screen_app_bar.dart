import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/widgets/just_play_screen/just_play_screen_drop_down_menu_widget.dart';

/// AppBar shown on the help screens
class HelpScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Required so I can return preferredSize
  final AppBar appBar;
  HelpScreenAppBar(this.appBar, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: MyColors.white),
      title: Text(
        MyStrings.helpScreenName,
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(this.appBar.preferredSize.height);
}
