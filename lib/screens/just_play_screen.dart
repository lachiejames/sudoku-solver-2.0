import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
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
  const JustPlayScreen({Key key}) : super(key: key);

  @override
  _JustPlayScreenState createState() => _JustPlayScreenState();
}

class _JustPlayScreenState extends State<JustPlayScreen> {
  @override
  void initState() {
    super.initState();
    showNewBannerAd();
  }

  @override
  void dispose() {
    disposeBannerAd();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Redux.store.dispatch(ChangeScreenAction(ScreenState.justPlayScreen));
    return StoreConnector<AppState, int>(
      distinct: true,
      converter: (Store<AppState> store) => store.state.gameNumber,
      builder: (BuildContext context, int gameNumber) {
        Redux.store.dispatch(LoadSudokuGameAction(gameNumber));
        return Scaffold(
          appBar: JustPlayScreenAppBar(AppBar()),
          backgroundColor: pink,
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const TopTextWidget(),
                  const NumberBarWidget(),
                  SudokuWidget(),
                  const NewGameButtonWidget(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
