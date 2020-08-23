import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/widgets/solve_with_touch_screen/solve_with_touch_screen_drop_down_menu_widget.dart';

class SolveWithCameraScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Required so I can return preferredSize
  final AppBar appBar;
  SolveWithCameraScreenAppBar(this.appBar, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: MyColors.white),
      title: Text(
        MyStrings.appBarTextSolveWithCameraScreen,
        style: MyStyles.appBarTextStyle,
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
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(this.appBar.preferredSize.height);
}
