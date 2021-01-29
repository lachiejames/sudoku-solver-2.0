import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/widgets/shared/sudoku_widget.dart';

import '../../constants/test_constants.dart';

void main() {
  group('SudokuWidget -', () {
    const Duration debounceTime = Duration(milliseconds: 100);
    SudokuWidget sudokuWidget;

    Future<void> createSudokuWidget(WidgetTester tester) async {
      sudokuWidget = SudokuWidget();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: sudokuWidget,
        ),
      );
    }

    setUp(() async {
      setMockMethodsForUnitTests();

      await Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createSudokuWidget(tester);

        expect(sudokuWidget, isNotNull);
      });

      testWidgets('should contain 81 empty tiles', (WidgetTester tester) async {
        await createSudokuWidget(tester);

        expect(find.text(''), findsNWidgets(81));
      });
    });

    group('after solving -', () {
      testWidgets('should NOT display a progress indicator', (WidgetTester tester) async {
        await createSudokuWidget(tester);

        await tester.runAsync(() async {
          Redux.store.dispatch(SolveSudokuAction());

          // Give it enough time to solve the sudoku
          await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
          await tester.pump(debounceTime);

          expect(find.byType(CircularProgressIndicator), findsNothing);
        });
      });
    });
  });
}
