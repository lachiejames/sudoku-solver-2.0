import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart';
import 'package:sudoku_solver_2/constants/my_styles.dart';
import 'package:sudoku_solver_2/constants/my_values.dart';
import 'package:sudoku_solver_2/constants/my_widgets.dart';
import 'package:sudoku_solver_2/models/sudoku_model.dart';
import 'package:sudoku_solver_2/models/tile_model.dart';
import 'package:sudoku_solver_2/models/top_text_model.dart';
import 'package:sudoku_solver_2/widgets/sudoku_widget.dart';
import 'package:sudoku_solver_2/widgets/tile_widget.dart';
import 'package:sudoku_solver_2/widgets/top_text_widget.dart';

class SolveWithTouchScreen extends StatefulWidget {
  SolveWithTouchScreen({Key key, this.title}) : super(key: key);

  final String title;

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
      key: Key('dropDownMenuButton_SolveWithTouchScreen'),
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
              child: Consumer<TopTextModel>(
                builder: (context, topTextModel, child) {
                  return RaisedButton(
                    key: Key('solveMySudokuButton_SolveWithTouchScreen'),
                    shape: MyStyles.buttonShape,
                    padding: MyStyles.buttonPadding,
                    color: MyColors.primaryTheme,
                    child: MyWidgets.makeButtonText('SOLVE MY SUDOKU'),
                    // Should be disabled while solving
                    onPressed: (false)
                        ? null
                        : () {
                            topTextModel.setText(MyStrings.topTextPickANumber);
                            // Provider.of<TopTextModel>(context, listen: false).updateText('pop dat pussy');
                            // context.watch<TopTextModel>().setText('pop dat pussy');
                          },
                  );
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TopTextModel>(create: (_) => TopTextModel()),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TopTextWidget(),
              makeSolveMySudokuButton(),
              TileWidget(
                tileModel: TileModel(row: 6, col: 9, value: 5),
              ),
              SudokuWidget(
                sudokuModel: SudokuModel(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
