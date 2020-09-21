import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/state/tile_state.dart';
import 'package:sudoku_solver_2/widgets/shared/tile_widget.dart';

void main() {
  group('TileWidget -', () {
    final Duration debounceTime = Duration(milliseconds: 100);
    final TileKey tileKey = TileKey(row: 1, col: 1);

    TileWidget tileWidget;

    Future<void> createTileWidget(WidgetTester tester) async {
      tileWidget = TileWidget(tileKey: tileKey);
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: tileWidget,
        ),
      );
    }

    Color getTileWidgetColor(WidgetTester tester) {
      return ((tester.firstWidget(find.byType(Container)) as Container).decoration as BoxDecoration)
          .color;
    }

    Future<void> addValueToSelectedTileWidget(WidgetTester tester, int value) async {
      var number = Redux.store.state.numberStateList[value - 1];
      Redux.store.dispatch(NumberPressedAction(number));
      await tester.pump(debounceTime);
    }

    void setIsOriginalTile() {
      TileState tileState = Redux.store.state.tileStateMap[tileKey];
      Redux.store.state.tileStateMap[tileKey] = tileState.copyWith(isOriginalTile: true);
    }

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await Redux.init();
    });

    group('initial state -', () {
      testWidgets('should contain no text', (WidgetTester tester) async {
        await createTileWidget(tester);
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('if its NOT an original tile, it should be white', (WidgetTester tester) async {
        await createTileWidget(tester);
        expect(getTileWidgetColor(tester), MyColors.white);
      });

      testWidgets('if its an original tile, it should be grey', (WidgetTester tester) async {
        setIsOriginalTile();
        await createTileWidget(tester);
        expect(getTileWidgetColor(tester), MyColors.grey);
      });
    });

    group('after being tapped once -', () {
      testWidgets('should turn green', (WidgetTester tester) async {
        await createTileWidget(tester);
        await tester.tap(find.byWidget(tileWidget));
        await tester.pump(debounceTime);
        expect(getTileWidgetColor(tester), MyColors.green);
      });

      testWidgets('should display a value when NumberPressedAction dispatched',
          (WidgetTester tester) async {
        await createTileWidget(tester);
        await tester.tap(find.byWidget(tileWidget));
        await addValueToSelectedTileWidget(tester, 1);
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('should NOT display an "X" too, if it has no value', (WidgetTester tester) async {
        await createTileWidget(tester);

        await tester.tap(find.byWidget(tileWidget));
        await tester.pump(debounceTime);

        expect(find.text('X'), findsNothing);
      });

      testWidgets('should display an "X" too, if it already has a value',
          (WidgetTester tester) async {
        await createTileWidget(tester);

        await tester.tap(find.byWidget(tileWidget));
        await addValueToSelectedTileWidget(tester, 1);

        await tester.tap(find.byWidget(tileWidget));
        await tester.pump(debounceTime);

        expect(find.text('X'), findsOneWidget);
      });
    });

    group('after being tapped twice -', () {
      testWidgets('should turn back to white', (WidgetTester tester) async {
        await createTileWidget(tester);
        await tester.tap(find.byWidget(tileWidget));
        await tester.pump(debounceTime);
        await tester.tap(find.byWidget(tileWidget));
        await tester.pump(debounceTime);
        expect(getTileWidgetColor(tester), MyColors.white);
      });

      testWidgets('should have value removed, if applicable', (WidgetTester tester) async {
        await createTileWidget(tester);

        // add value to tile
        await tester.tap(find.byWidget(tileWidget));
        await addValueToSelectedTileWidget(tester, 1);
        expect(find.text('1'), findsOneWidget);

        // double tap tile
        await tester.tap(find.byWidget(tileWidget));
        await tester.pump(debounceTime);
        await tester.tap(find.byWidget(tileWidget));
        await tester.pump(debounceTime);
        expect(find.text(''), findsOneWidget);
      });
    });
  });
}
