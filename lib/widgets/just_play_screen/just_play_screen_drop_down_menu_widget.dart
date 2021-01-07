import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart' as constants;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/just_play_help_screen.dart';
import 'package:sudoku_solver_2/widgets/shared/slide_animated_route.dart';

/// Drop down menu on the JustPlayScreen
class JustPlayScreenDropDownMenuWidget extends StatelessWidget {
  JustPlayScreenDropDownMenuWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: constants.white,
      ),
      style: constants.dropDownMenuTextStyle,
      items: _createDropdownMenuItems(),
      onChanged: (value) async {
        await this._performAction(value, context);
      },
    );
  }

  List<DropdownMenuItem<String>> _createDropdownMenuItems() {
    return <String>[
      constants.dropDownMenuOption1,
      constants.dropDownMenuOption2,
    ].map(
      (String value) {
        return this._createDropdownMenuItem(value);
      },
    ).toList();
  }

  DropdownMenuItem<String> _createDropdownMenuItem(String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(
        value,
        textDirection: TextDirection.ltr,
      ),
    );
  }

  void _performAction(String value, BuildContext context) async {
    if (value == constants.dropDownMenuOption1) {
      _restart();
    } else if (value == constants.dropDownMenuOption2) {
      await _navigateToJustPlayHelpScreen(context);
    }
  }

  void _restart() {
    Redux.store.dispatch(RestartAction());
  }

  void _navigateToJustPlayHelpScreen(BuildContext context) async {
    await Navigator.push(
      context,
      SlideAnimatedRoute(
        nextPage: JustPlayHelpScreen(),
        routeSettings: RouteSettings(name: '/just-play/help'),
      ),
    );
  }
}
