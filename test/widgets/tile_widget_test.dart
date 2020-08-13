import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/widgets/tile_widget.dart';

void main() {
  group('TileWidget -', () {
    final Duration debounceTime = Duration(milliseconds: 100);
    TileWidget tileWidget;

    Future<void> createTileWidget(WidgetTester tester) async {
      tileWidget = TileWidget(tileKey: TileKey(row: 1, col: 1));
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: tileWidget,
        ),
      );
    }

    Color getTileWidgetColor(WidgetTester tester) {
      return ((tester.firstWidget(find.byType(Container)) as Container).decoration as BoxDecoration).color;
    }

    Future<void> addValueToSelectedTileWidget(WidgetTester tester, int value) async {
      var number = Redux.store.state.numberStateList[value - 1];
      Redux.store.dispatch(NumberPressedAction(number));
      await tester.pump(debounceTime);
    }

    setUp(() {
      Redux.init();
    });

    group('initial state -', () {
      testWidgets('should initially contain no text', (WidgetTester tester) async {
        await createTileWidget(tester);
        expect(find.text(''), findsOneWidget);
      });

      testWidgets('should initially be white', (WidgetTester tester) async {
        await createTileWidget(tester);
        expect(getTileWidgetColor(tester), MyColors.white);
      });
    });

    group('after being tapped once -', () {
      testWidgets('should turn green', (WidgetTester tester) async {
        await createTileWidget(tester);
        await tester.tap(find.byWidget(tileWidget));
        await tester.pump(debounceTime);
        expect(getTileWidgetColor(tester), MyColors.green);
      });

      testWidgets('should display a value when NumberPressedAction dispatched', (WidgetTester tester) async {
        await createTileWidget(tester);
        await tester.tap(find.byWidget(tileWidget));
        await addValueToSelectedTileWidget(tester, 1);
        expect(find.text('1'), findsOneWidget);
      });
    });

    group('after being tapped twice -', () {
      testWidgets('should turn back to white', (WidgetTester tester) async {
        await createTileWidget(tester);
        await tester.tap(find.byWidget(tileWidget));
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
