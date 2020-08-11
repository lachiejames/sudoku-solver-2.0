import 'package:flutter/material.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/widgets/number_bar_widget.dart';
import 'package:sudoku_solver_2/widgets/sudoku_widget.dart';
import 'package:sudoku_solver_2/widgets/top_text_widget.dart';

class SolveWithTouchScreen extends StatefulWidget {
  @override
  _SolveWithTouchScreenState createState() => _SolveWithTouchScreenState();
}

class _SolveWithTouchScreenState extends State<SolveWithTouchScreen> {
  Widget makeAppBar(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: MyColors.white),
      title: Text(
        MyStrings.appBarTextSolveWithTouchScreen,
        style: MyStyles.appBarTextStyle,
        textDirection: TextDirection.ltr,
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
            child: Text(
              value,
              textDirection: TextDirection.ltr,
            ),
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
                onPressed: () {
                  Redux.store.dispatch(SolveButtonPressedAction());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          MyStrings.appBarTextSolveWithTouchScreen,
          textDirection: TextDirection.ltr,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TopTextWidget(),
            NumberBarWidget(),
            SudokuWidget(),
            makeSolveMySudokuButton(),
          ],
        ),
      ),
    );
  }
}
