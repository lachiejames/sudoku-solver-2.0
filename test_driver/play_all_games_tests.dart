@Skip('play-all-games integration test')

import 'package:flutter_driver/flutter_driver.dart';
import 'package:sudoku_solver_2/constants/my_strings.dart' as my_strings;
import 'package:sudoku_solver_2/state/tile_key.dart';
import 'package:test/test.dart';

import 'my_solved_games.dart' as my_solved_games;
import 'shared.dart';

void main() {
  FlutterDriver driver;

  void navigateToJustPlayScreen() async {
    await waitForThenTap(driver, find.text(my_strings.justPlayButtonText));
    await driver.getText(find.text(my_strings.topTextNoTileSelected));
  }

  void tapTile(TileKey tileKey) async {
    await waitForThenTap(driver, find.byValueKey('${tileKey.toString()}'));
  }

  void tapNumber(int number) async {
    await waitForThenTap(driver, find.byValueKey('Number($number)'));
  }

  void addNumberToTile(int number, TileKey tileKey) async {
    await tapTile(tileKey);
    await tapNumber(number);
  }

  void tapNewGameButton() async {
    await waitForThenTap(driver, find.text('NEW GAME'));
  }

  Future<int> getNumberOnTile(TileKey tileKey) async {
    await driver.waitUntilNoTransientCallbacks();
    String tileText = await driver.getText(await find.byValueKey('${tileKey.toString()}_text'));

    if (tileText == "") {
      return null;
    } else {
      return int.parse(tileText);
    }
  }

  Future<void> playGame(List<List<int>> game) async {
    for (int row = 1; row <= 9; row++) {
      for (int col = 1; col <= 9; col++) {
        int numberOnTile = await getNumberOnTile(TileKey(row: row, col: col));
        if (numberOnTile == null) {
          await addNumberToTile(game[row - 1][col - 1], TileKey(row: row, col: col));
        }
      }
    }
  }

  group('JustPlayScreenAllGames tests ->', () {
    setUpAll(() async {
      await grantAppPermissions();
      driver = await FlutterDriver.connect(dartVmServiceUrl: my_strings.dartVMServiceUrl);
      await hotRestart(driver);
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
    });

    setUp(() async {
      await hotRestart(driver);
      await navigateToJustPlayScreen();
    });

    test('can play all 10 games in a row', () async {
      for (int i = 0; i < my_solved_games.solvedGamesList.length; i++) {
        await playGame(my_solved_games.solvedGamesList[i]);
        await tapNewGameButton();
      }
    }, timeout: Timeout(Duration(seconds: 300)));
  });
}
