import 'my_solved_games.dart';

class TestConstants {
  static final List<String> solvedGames = [
    MySolvedGames.game0ValuesStringSolved,
    MySolvedGames.game1ValuesStringSolved,
    MySolvedGames.game2ValuesStringSolved,
    MySolvedGames.game3ValuesStringSolved,
    MySolvedGames.game4ValuesStringSolved,
    MySolvedGames.game5ValuesStringSolved,
    MySolvedGames.game6ValuesStringSolved,
    MySolvedGames.game7ValuesStringSolved,
    MySolvedGames.game8ValuesStringSolved,
    MySolvedGames.game9ValuesStringSolved,
  ];

  static final String emptySudokuString = '''
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
|   |   |   |   |   |   |   |   |   |
-------------------------------------
''';

  static final String game1ValuesListString = '''
-------------------------------------
|   |   |   | 5 | 4 | 3 | 9 |   |   |
-------------------------------------
|   |   | 7 |   |   |   |   |   |   |
-------------------------------------
|   |   |   | 6 |   |   |   | 3 |   |
-------------------------------------
|   |   |   |   |   |   |   |   | 6 |
-------------------------------------
|   |   | 8 | 9 |   |   |   |   |   |
-------------------------------------
|   |   | 9 |   | 8 | 4 |   |   |   |
-------------------------------------
|   | 7 |   |   |   |   |   |   | 4 |
-------------------------------------
|   | 3 |   |   |   | 6 |   | 2 |   |
-------------------------------------
| 2 |   | 4 |   | 1 |   |   | 7 |   |
-------------------------------------
''';

  static final List<List<int>> game2ValuesListSolved = [
    [8, 2, 1, 4, 9, 7, 3, 5, 6],
    [6, 9, 5, 1, 3, 2, 7, 4, 8],
    [3, 4, 7, 6, 5, 8, 9, 2, 1],
    [4, 7, 9, 2, 6, 3, 1, 8, 5],
    [2, 1, 8, 9, 7, 5, 4, 6, 3],
    [5, 3, 6, 8, 4, 1, 2, 7, 9],
    [1, 5, 3, 7, 2, 6, 8, 9, 4],
    [7, 8, 4, 5, 1, 9, 6, 3, 2],
    [9, 6, 2, 3, 8, 4, 5, 1, 7],
  ];

  static final String game1TilesInRow1String =
      '[TileState(row=1, col=1, value=null, isSelected=false), TileState(row=1, col=2, value=null, isSelected=false), TileState(row=1, col=3, value=null, isSelected=false), TileState(row=1, col=4, value=5, isSelected=false), TileState(row=1, col=5, value=4, isSelected=false), TileState(row=1, col=6, value=3, isSelected=false), TileState(row=1, col=7, value=9, isSelected=false), TileState(row=1, col=8, value=null, isSelected=false), TileState(row=1, col=9, value=null, isSelected=false)]';

  static final String game1TilesInCol3String =
      '[TileState(row=1, col=3, value=null, isSelected=false), TileState(row=2, col=3, value=7, isSelected=false), TileState(row=3, col=3, value=null, isSelected=false), TileState(row=4, col=3, value=null, isSelected=false), TileState(row=5, col=3, value=8, isSelected=false), TileState(row=6, col=3, value=9, isSelected=false), TileState(row=7, col=3, value=null, isSelected=false), TileState(row=8, col=3, value=null, isSelected=false), TileState(row=9, col=3, value=4, isSelected=false)]';

  static final String game1TilesInSegment2String =
      '[TileState(row=1, col=4, value=5, isSelected=false), TileState(row=1, col=5, value=4, isSelected=false), TileState(row=1, col=6, value=3, isSelected=false), TileState(row=2, col=4, value=null, isSelected=false), TileState(row=2, col=5, value=null, isSelected=false), TileState(row=2, col=6, value=null, isSelected=false), TileState(row=3, col=4, value=6, isSelected=false), TileState(row=3, col=5, value=null, isSelected=false), TileState(row=3, col=6, value=null, isSelected=false)]';
}
