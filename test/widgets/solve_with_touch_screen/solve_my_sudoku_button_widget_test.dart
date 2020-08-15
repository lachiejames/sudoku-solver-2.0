import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/widgets/solve_with_touch_screen/solve_my_sudoku_button_widget.dart';

void main() {
  group('SolveMySudokuButtonWidget -', () {
    final Duration debounceTime = Duration(milliseconds: 100);
    SolveMySudokuButtonWidget solveMySudokuButtonWidget;

    Future<void> createSolveMySudokuButtonWidget(WidgetTester tester) async {
      solveMySudokuButtonWidget = SolveMySudokuButtonWidget();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: solveMySudokuButtonWidget,
        ),
      );
    }

    Color getSolveMySudokuButtonWidgetColor(WidgetTester tester) {
      return ((tester.firstWidget(find.byType(RaisedButton)) as RaisedButton)).color;
    }

    setUp(() {
      Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createSolveMySudokuButtonWidget(tester);

        expect(solveMySudokuButtonWidget, isNotNull);
      });

      testWidgets('should display "SOLVE MY SUDOKU"', (WidgetTester tester) async {
        await createSolveMySudokuButtonWidget(tester);

        expect(find.text('SOLVE MY SUDOKU'), findsOneWidget);
      });

      testWidgets('should be blue', (WidgetTester tester) async {
        await createSolveMySudokuButtonWidget(tester);

        expect(getSolveMySudokuButtonWidgetColor(tester), MyColors.blue);
      });
    });

    group('after being tapped -', () {
      testWidgets('should turn grey', (WidgetTester tester) async {
        await createSolveMySudokuButtonWidget(tester);

        await tester.tap(find.byWidget(solveMySudokuButtonWidget));
        await tester.pump(debounceTime);

        expect(getSolveMySudokuButtonWidgetColor(tester), MyColors.grey);
      });

      testWidgets('should start solving the sudoku', (WidgetTester tester) async {
        await createSolveMySudokuButtonWidget(tester);

        await tester.tap(find.byWidget(solveMySudokuButtonWidget));
        await tester.pump(debounceTime);

        expect(Redux.store.state.isSolving, true);
      });
    });

    group('after sudoku is solved -', () {
      testWidgets('should turn back to blue', (WidgetTester tester) async {
        await createSolveMySudokuButtonWidget(tester);

        // Uses real a real async instead of fakeAsync like other tests
        await tester.runAsync(() async {
          await tester.tap(find.byWidget(solveMySudokuButtonWidget));

          // Becomes grey while solving
          await tester.pump(debounceTime);
          expect(getSolveMySudokuButtonWidgetColor(tester), MyColors.grey);

          // Give it enough time to solve the sudoku
          await Future.delayed(Duration(milliseconds: 1000));

          // Turns back to blue after solving
          await tester.pump(debounceTime);
          expect(getSolveMySudokuButtonWidgetColor(tester), MyColors.blue);
        });
      });

      testWidgets('should have stopped solving the sudoku', (WidgetTester tester) async {
        await createSolveMySudokuButtonWidget(tester);

        // Uses real a real async instead of fakeAsync like other tests
        await tester.runAsync(() async {
          await tester.tap(find.byWidget(solveMySudokuButtonWidget));

          expect(Redux.store.state.isSolving, true);

          // Give it enough time to solve the sudoku
          await Future.delayed(Duration(milliseconds: 1000));
          
          expect(Redux.store.state.isSolving, false);
        });
      });
    });
  });
}
