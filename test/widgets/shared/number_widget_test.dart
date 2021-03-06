import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/constants/constants.dart';
import 'package:sudoku_solver_2/redux/actions.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/widgets/shared/number_widget.dart';

import '../../constants/test_constants.dart';

void main() {
  group('NumberWidget -', () {
    const Duration debounceTime = Duration(milliseconds: 100);
    const TileKey tileKey = TileKey(row: 1, col: 1);
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

    Future<void> tapTileWidget(WidgetTester tester) async {
      Redux.store.dispatch(TileSelectedAction(Redux.store.state.tileStateMap[tileKey]));
      await tester.pump(debounceTime);
    }

    Future<void> tapNumberWidget(WidgetTester tester) async {
      await tester.tap(find.byWidget(numberWidget));
      await tester.pump(debounceTime);
    }

    Color getNumberWidgetColor(WidgetTester tester) {
      final Container container = tester.firstWidget(find.byType(Container));
      final ShapeDecoration shapeDecoration = container.decoration;
      return shapeDecoration.color;
    }

    setUp(() async {
      setMockMethodsForUnitTests();
      await Redux.init();
    });

    group('initial state -', () {
      testWidgets('should contain a number', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);
        expect(find.text('1'), findsOneWidget);
      });

      testWidgets('should be white', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);
        expect(getNumberWidgetColor(tester), white);
      });

      testWidgets('not tappable', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);

        await tapNumberWidget(tester);

        expect(getNumberWidgetColor(tester), white);
      });
    });

    group('after a tile was selected -', () {
      testWidgets('numberWidget should be green', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);

        await tapTileWidget(tester);

        expect(getNumberWidgetColor(tester), green);
      });

      testWidgets('tapping this numberWidget sets color back to white', (WidgetTester tester) async {
        await createNumberWidget(tester, 1);

        await tapNumberWidget(tester);

        expect(getNumberWidgetColor(tester), white);
      });

      //   testWidgets('tapping this numberWidget caused tile to display this number',
      //       (WidgetTester tester) async {
      //     await createNumberWidget(tester, 1);

      //     await tapTileWidget(tester);
      //     await tapNumberWidget(tester);

      //     expect(Redux.store.state.tileStateMap[tileKey].value, 1);
      //   });
    });
  });
}
