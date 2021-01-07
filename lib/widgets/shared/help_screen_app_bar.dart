import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;

/// AppBar shown on the help screens
class HelpScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Required so I can return preferredSize
  final AppBar appBar;
  HelpScreenAppBar(this.appBar, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: constants.white),
      title: Text(
        constants.helpScreenName,
        style: constants.appBarTextStyle,
        textDirection: TextDirection.ltr,
      ),

      leading: IconButton(
        onPressed: () async {
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
