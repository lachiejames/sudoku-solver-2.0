import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart' as my_colors;
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/game_state.dart';
import 'package:sudoku_solver_2/widgets/solve_with_touch_screen/solve_sudoku_button_widget.dart';

void main() {
  group('SolveSudokuButtonWidget -', () {
    final Duration debounceTime = Duration(milliseconds: 100);
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

    Color getSolveSudokuButtonWidgetColor(WidgetTester tester) {
      return ((tester.firstWidget(find.byType(RaisedButton)) as RaisedButton)).color;
    }

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createSolveSudokuButtonWidget(tester);

        expect(solveSudokuButtonWidget, isNotNull);
      });

      testWidgets('should display "SOLVE MY SUDOKU"', (WidgetTester tester) async {
        await createSolveSudokuButtonWidget(tester);

        expect(find.text('SOLVE MY SUDOKU'), findsOneWidget);
      });

      testWidgets('should be blue', (WidgetTester tester) async {
        await createSolveSudokuButtonWidget(tester);

        expect(getSolveSudokuButtonWidgetColor(tester), my_colors.blue);
      });
    });

    group('after being tapped -', () {
      testWidgets('should turn red', (WidgetTester tester) async {
        await createSolveSudokuButtonWidget(tester);

        await tester.tap(find.byWidget(solveSudokuButtonWidget));
        await tester.pump(debounceTime);

        expect(getSolveSudokuButtonWidgetColor(tester), my_colors.red);
      });

      testWidgets('should start solving the sudoku', (WidgetTester tester) async {
        await createSolveSudokuButtonWidget(tester);

        await tester.tap(find.byWidget(solveSudokuButtonWidget));
        await tester.pump(debounceTime);

        expect(Redux.store.state.gameState == GameState.isSolving, true);
      });
    });

    group('after sudoku is solved -', () {
      testWidgets('should turn back to blue', (WidgetTester tester) async {
        await createSolveSudokuButtonWidget(tester);

        // Uses real a real async instead of fakeAsync like other tests
        await tester.runAsync(() async {
          await tester.tap(find.byWidget(solveSudokuButtonWidget));

          // Becomes grey while solving
          await tester.pump(debounceTime);
          expect(getSolveSudokuButtonWidgetColor(tester), my_colors.red);

          // Give it enough time to solve the sudoku
          await Future.delayed(Duration(milliseconds: 1000));

          // Turns back to blue after solving
          await tester.pump(debounceTime);
          expect(getSolveSudokuButtonWidgetColor(tester), my_colors.blue);
        });
      });

      testWidgets('should have stopped solving the sudoku', (WidgetTester tester) async {
        await createSolveSudokuButtonWidget(tester);

        // Uses real a real async instead of fakeAsync like other tests
        await tester.runAsync(() async {
          await tester.tap(find.byWidget(solveSudokuButtonWidget));

          expect(Redux.store.state.gameState == GameState.isSolving, true);

          // Give it enough time to solve the sudoku
          await Future.delayed(Duration(milliseconds: 1000));

          expect(Redux.store.state.gameState == GameState.isSolving, false);
        });
      });
    });
  });
}
