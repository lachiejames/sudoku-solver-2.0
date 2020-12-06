import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/constants/my_values.dart' as my_values;
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/screen_state.dart';
import 'package:sudoku_solver_2/widgets/just_play_screen/just_play_screen_app_bar.dart';
import 'package:sudoku_solver_2/widgets/just_play_screen/new_game_button_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/number_bar_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/sudoku_widget.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';

/// Shown when 'just play' is selected from the HomeScreen
class JustPlayScreen extends StatefulWidget {
  JustPlayScreen({Key key}) : super(key: key);

  @override
  _JustPlayScreenState createState() => _JustPlayScreenState();
}

class _JustPlayScreenState extends State<JustPlayScreen> {
  @override
  void initState() {
    super.initState();
    my_values.firebaseAnalytics.setCurrentScreen(screenName: 'JustPlayScreen');
  }

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.justPlayScreen));
    return StoreConnector<AppState, int>(
      distinct: true,
      converter: (store) => store.state.gameNumber,
      builder: (context, gameNumber) {
        Redux.store.dispatch(LoadSudokuGameAction(gameNumber));
        return Scaffold(
          appBar: JustPlayScreenAppBar(AppBar()),
          backgroundColor: my_colors.pink,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TopTextWidget(),
                  NumberBarWidget(),
                  SudokuWidget(),
                  NewGameButtonWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
