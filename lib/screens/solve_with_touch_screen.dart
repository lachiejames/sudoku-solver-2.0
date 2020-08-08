import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/state/sudoku_state.dart';
import 'package:sudoku_solver_2/widgets/number_bar_widget.dart';
import 'package:sudoku_solver_2/widgets/sudoku_widget.dart';
import 'package:sudoku_solver_2/widgets/top_text_widget.dart';

class SolveWithTouchScreen extends StatefulWidget {
  @override
  _SolveWithTouchScreenState createState() => _SolveWithTouchScreenState();
}

class _SolveWithTouchScreenState extends State<SolveWithTouchScreen> {
  GameState gameState = GameState();

  Widget makeAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: MyColors.white),
      title: Text(
        MyStrings.appBarTextSolveWithTouchScreen,
        style: MyStyles.appBarTextStyle,
      ),
      actions: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: MyValues.screenWidth / 18),
          child: GestureDetector(
            onTap: () {},
            child: makeDropDownMenu(),
          ),
        ),
      ],
    );
  }

  Widget makeDropDownMenu() {
    return DropdownButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: MyColors.white,
      ),
      style: TextStyle(
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      items: <String>[
        'Restart',
        MyStrings.appBarTextHowToSolveScreen,
      ].map(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
      onChanged: (value) {
        if (value == 'Restart') {
          restart();
        } else if (value == MyStrings.appBarTextHowToSolveScreen) {
          navigateToHowToSolveScreen(context);
        }
      },
    );
  }

  void restart() {}

  void navigateToHowToSolveScreen(BuildContext context) {}

  Widget makeSolveMySudokuButton() {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        margin: MyStyles.buttonMargins,
        child: Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                shape: MyStyles.buttonShape,
                padding: MyStyles.buttonPadding,
                color: MyColors.primaryTheme,
                child: MyWidgets.makeButtonText('SOLVE MY SUDOKU'),
                // Should be disabled while solving
                onPressed: null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: this.gameState),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(MyStrings.appBarTextSolveWithTouchScreen),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TopTextWidget(),
              NumberBarWidget(),
              SudokuWidget(
                sudokuState: SudokuState(),
              ),
              makeSolveMySudokuButton(),
            ],
          ),
        ),
      ),
    );
  }
}
