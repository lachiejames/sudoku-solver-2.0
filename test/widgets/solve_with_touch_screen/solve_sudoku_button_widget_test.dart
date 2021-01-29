import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/widgets/shared/solve_sudoku_button_widget.dart';

import '../../constants/test_constants.dart';

void main() {
  group('SolveSudokuButtonWidget -', () {
    SolveSudokuButtonWidget solveSudokuButtonWidget;

    Future<void> createSolveSudokuButtonWidget(WidgetTester tester) async {
      solveSudokuButtonWidget = SolveSudokuButtonWidget();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: solveSudokuButtonWidget,
        ),
      );
    }

    Color getSolveSudokuButtonWidgetColor(WidgetTester tester) =>
        (tester.firstWidget<RaisedButton>(find.byType(RaisedButton))).color;

    setUp(() async {
      setMockMethodsForUnitTests();
      await Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createSolveSudokuButtonWidget(tester);

        expect(solveSudokuButtonWidget, isNotNull);
      });

      testWidgets('should display "SOLVE SUDOKU"', (WidgetTester tester) async {
        await createSolveSudokuButtonWidget(tester);

        expect(find.text('SOLVE SUDOKU'), findsOneWidget);
      });

      testWidgets('should be blue', (WidgetTester tester) async {
        await createSolveSudokuButtonWidget(tester);

        expect(getSolveSudokuButtonWidgetColor(tester), blue);
      });
    });
  });
}
