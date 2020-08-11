import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudoku_solver_2/redux/redux.dart';
import 'package:sudoku_solver_2/state/app_state.dart';
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:sudoku_solver_2/widgets/tile_widget.dart';

void main() {
  group('TileWidget', () {
    setUpAll(() {
      Redux.init();
    });
    testWidgets('Counter increments smoke test', (WidgetTester tester) async {
      await tester.pumpWidget(
        StoreProvider<AppState>(
          store: Redux.store,
          child: TileWidget(
            tileKey: TileKey(row: 1, col: 1),
          ),
        ),
      );
    });
  });
}
