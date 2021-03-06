import 'dart:async';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/widgets/shared/top_text_widget.dart';

import '../../constants/test_constants.dart';

void main() {
  group('TopTextWidget -', () {
    const Duration debounceTime = Duration(milliseconds: 100);
    const TileKey tileKey = TileKey(row: 1, col: 1);
    TopTextWidget topTextWidget;

    Future<void> createNumberBarWidget(WidgetTester tester) async {
      topTextWidget = const TopTextWidget();
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: topTextWidget,
        ),
      );
    }

    setUp(() async {
      setMockMethodsForUnitTests();
      await Redux.init();
    });

    group('initial state -', () {
      testWidgets('should be defined', (WidgetTester tester) async {
        await createNumberBarWidget(tester);

        expect(topTextWidget, isNotNull);
      });

      testWidgets('should display "Pick a tile"', (WidgetTester tester) async {
        await createNumberBarWidget(tester);

        expect(find.text('Pick a tile'), findsOneWidget);
      });
    });

    group('after tile is pressed -', () {
      testWidgets('should display "Pick a number", if tile has no value', (WidgetTester tester) async {
        await createNumberBarWidget(tester);

        Redux.store.dispatch(TileSelectedAction(Redux.store.state.tileStateMap[tileKey]));
        await tester.pump(debounceTime);

        expect(find.text('Pick a number'), findsOneWidget);
      });

      testWidgets('should display "Tap to remove", if tile has a value', (WidgetTester tester) async {
        await createNumberBarWidget(tester);

        Redux.store.state.tileStateMap[tileKey] = Redux.store.state.tileStateMap[tileKey].copyWith(value: 1);
        Redux.store.dispatch(TileSelectedAction(Redux.store.state.tileStateMap[tileKey]));
        await tester.pump(debounceTime);

        expect(find.text('Tap to remove'), findsOneWidget);
      });

      testWidgets('should display "Pick a tile", if tile is pressed again', (WidgetTester tester) async {
        await createNumberBarWidget(tester);

        Redux.store.dispatch(TileSelectedAction(Redux.store.state.tileStateMap[tileKey]));
        await tester.pump(debounceTime);
        Redux.store.dispatch(TileDeselectedAction(Redux.store.state.tileStateMap[tileKey]));
        await tester.pump(debounceTime);

        expect(find.text('Pick a tile'), findsOneWidget);
      });
    });

    group('while solving -', () {
      testWidgets('should display "AI thinking..."', (WidgetTester tester) async {
        await createNumberBarWidget(tester);

        Redux.store.dispatch(SolveSudokuAction());
        await tester.pump(debounceTime);

        expect(find.text('AI thinking...'), findsOneWidget);
      });

      testWidgets('should display "SOLVED" after solving', (WidgetTester tester) async {
        await createNumberBarWidget(tester);

        await tester.runAsync(() async {
          Redux.store.dispatch(SolveSudokuAction());

          // Give it enough time to solve the sudoku
          await Future<dynamic>.delayed(const Duration(milliseconds: 1000));
          await tester.pump(debounceTime);

          expect(find.text('SOLVED'), findsOneWidget);
        });
      });
    });
  });
}
