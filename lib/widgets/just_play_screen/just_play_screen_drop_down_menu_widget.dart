import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/screens/just_play_help_screen.dart';
import 'package:sudoku_solver_2/widgets/shared/slide_animated_route.dart';

/// Drop down menu on the JustPlayScreen
class JustPlayScreenDropDownMenuWidget extends StatelessWidget {
  const JustPlayScreenDropDownMenuWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DropdownButton<String>(
        icon: const Icon(
          Icons.more_vert,
          color: white,
        ),
        style: dropDownMenuTextStyle,
        items: _createDropdownMenuItems(),
        onChanged: (String value) async {
          await _performAction(value, context);
        },
      );

  List<DropdownMenuItem<String>> _createDropdownMenuItems() => <String>[
        dropDownMenuOption1,
        dropDownMenuOption2,
      ]
          .map(
            _createDropdownMenuItem,
          )
          .toList();

  DropdownMenuItem<String> _createDropdownMenuItem(String value) => DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          textDirection: TextDirection.ltr,
        ),
      );

  Future<void> _performAction(String value, BuildContext context) async {
    if (value == dropDownMenuOption1) {
      _restart();
    } else if (value == dropDownMenuOption2) {
      await _navigateToJustPlayHelpScreen(context);
    }
  }

  void _restart() {
    Redux.store.dispatch(RestartAction());
  }

  Future<void> _navigateToJustPlayHelpScreen(BuildContext context) async {
    await Navigator.push(
      context,
      SlideAnimatedRoute(
        nextPage: const JustPlayHelpScreen(),
        routeSettings: const RouteSettings(name: '/just-play/help'),
      ),
    );
  }
}
