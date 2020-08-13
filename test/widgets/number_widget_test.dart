import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/my_colors.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/widgets/number_widget.dart';

void main() {
  group('NumberWidget -', () {
    final Duration debounceTime = Duration(milliseconds: 100);
    NumberWidget numberWidget;

    Future<void> createNumberWidget(WidgetTester tester, int number) async {
      numberWidget = NumberWidget(number: number);
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: numberWidget,
        ),
      );
    }

    Color getNumberWidgetColor(WidgetTester tester) {
      return ((tester.firstWidget(find.byType(Container)) as Container).decoration as ShapeDecoration).color;
    }

    setUp(() {
      Redux.init();
    });

    group('initial state -', () {
      testWidgets('should contain a number', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('should be white', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);
        expect(getNumberWidgetColor(tester), MyColors.white);
      });

      testWidgets('not tappable', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);

        await tester.tap(find.byWidget(numberWidget));
        await tester.pump(debounceTime);

        expect(getNumberWidgetColor(tester), MyColors.white);
      });
    });

    group('after a tile was selected -', () {
      testWidgets('should be green', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);
        Redux.store.dispatch(TileSelectedAction(Redux.store.state.tileStateMap[TileKey(row: 1, col: 1)]));

        expect(getNumberWidgetColor(tester), MyColors.green);
      });

      testWidgets('tapping sets color back to white', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);
        Redux.store.dispatch(TileSelectedAction(Redux.store.state.tileStateMap[TileKey(row: 1, col: 1)]));

        await tester.tap(find.byWidget(numberWidget));
        await tester.pump(debounceTime);

        expect(getNumberWidgetColor(tester), MyColors.white);
      });

      testWidgets('tapping caused tile to display this number', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);
        Redux.store.dispatch(TileSelectedAction(Redux.store.state.tileStateMap[TileKey(row: 1, col: 1)]));

        await tester.tap(find.byWidget(numberWidget));
        await tester.pump(debounceTime);

        expect(Redux.store.state.tileStateMap[TileKey(row: 1, col: 1)].value, 1);
      });
    });
  });
}
