import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';

/// AppBar shown on the help screens
class HelpScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Required so I can return preferredSize
  final AppBar appBar;
  const HelpScreenAppBar(this.appBar, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AppBar(
        iconTheme: const IconThemeData(color: white),
        title: const Text(
          helpScreenName,
          style: appBarTextStyle,
          textDirection: TextDirection.ltr,
        ),
        leading: IconButton(
          onPressed: () async {
            await playSound(buttonPressedSound);
            await logEvent('button_back');
            Navigator.pop(context);
          },
          icon: (Platform.isAndroid) ? const Icon(Icons.arrow_back) : const Icon(Icons.arrow_back_ios),
        ),
      );

  @override
  Size get preferredSize => Size.fromHeight(appBar.preferredSize.height);
}
