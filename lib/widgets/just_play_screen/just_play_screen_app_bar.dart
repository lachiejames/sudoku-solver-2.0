import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/widgets/just_play_screen/just_play_screen_drop_down_menu_widget.dart';

/// AppBar on the JustPlayScreen
class JustPlayScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Required so I can return preferredSize
  final AppBar appBar;
  const JustPlayScreenAppBar(this.appBar, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => AppBar(
        iconTheme: const IconThemeData(color: white),
        title: const Text(
          justPlayScreenName,
          style: appBarTextStyle,
          textDirection: TextDirection.ltr,
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: GestureDetector(
              child: const JustPlayScreenDropDownMenuWidget(),
            ),
          ),
        ],
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
