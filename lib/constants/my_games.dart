class MyGames {
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

  static final List<List<int>> game0ValuesList = [
    [5, 3, null, null, 7, null, null, null, null],
    [6, null, null, 1, 9, 5, null, null, null],
    [null, 9, 8, null, null, null, null, 6, null],
    [8, null, null, null, 6, null, null, null, 3],
    [4, null, null, 8, null, 3, null, null, 1],
    [7, null, null, null, 2, null, null, null, 6],
    [null, 6, null, null, null, null, 2, 8, null],
    [null, null, null, 4, 1, 9, null, null, 5],
    [null, null, null, null, 8, null, null, 7, 9],
  ];

  static final String game0ValuesStringSolved = '''
-------------------------------------
| 5 | 3 | 4 | 6 | 7 | 8 | 9 | 1 | 2 |
-------------------------------------
| 6 | 7 | 2 | 1 | 9 | 5 | 3 | 4 | 8 |
-------------------------------------
| 1 | 9 | 8 | 3 | 4 | 2 | 5 | 6 | 7 |
-------------------------------------
| 8 | 5 | 9 | 7 | 6 | 1 | 4 | 2 | 3 |
-------------------------------------
| 4 | 2 | 6 | 8 | 5 | 3 | 7 | 9 | 1 |
-------------------------------------
| 7 | 1 | 3 | 9 | 2 | 4 | 8 | 5 | 6 |
-------------------------------------
| 9 | 6 | 1 | 5 | 3 | 7 | 2 | 8 | 4 |
-------------------------------------
| 2 | 8 | 7 | 4 | 1 | 9 | 6 | 3 | 5 |
-------------------------------------
| 3 | 4 | 5 | 2 | 8 | 6 | 1 | 7 | 9 |
-------------------------------------
''';

// Hard one
  static final List<List<int>> game1ValuesList = [
    [null, null, null, 5, 4, 3, 9, null, null],
    [null, null, 7, null, null, null, null, null, null],
    [null, null, null, 6, null, null, null, 3, null],
    [null, null, null, null, null, null, null, null, 6],
    [null, null, 8, 9, null, null, null, null, null],
    [null, null, 9, null, 8, 4, null, null, null],
    [null, 7, null, null, null, null, null, null, 4],
    [null, 3, null, null, null, 6, null, 2, null],
    [2, null, 4, null, 1, null, null, 7, null],
  ];

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

  static final String game1TilesInRow1String =
      '[TileState(row=1, col=1, value=null, isTapped=false), TileState(row=1, col=2, value=null, isTapped=false), TileState(row=1, col=3, value=null, isTapped=false), TileState(row=1, col=4, value=5, isTapped=false), TileState(row=1, col=5, value=4, isTapped=false), TileState(row=1, col=6, value=3, isTapped=false), TileState(row=1, col=7, value=9, isTapped=false), TileState(row=1, col=8, value=null, isTapped=false), TileState(row=1, col=9, value=null, isTapped=false)]';

  static final String game1TilesInCol3String =
      '[TileState(row=1, col=3, value=null, isTapped=false), TileState(row=2, col=3, value=7, isTapped=false), TileState(row=3, col=3, value=null, isTapped=false), TileState(row=4, col=3, value=null, isTapped=false), TileState(row=5, col=3, value=8, isTapped=false), TileState(row=6, col=3, value=9, isTapped=false), TileState(row=7, col=3, value=null, isTapped=false), TileState(row=8, col=3, value=null, isTapped=false), TileState(row=9, col=3, value=4, isTapped=false)]';

  static final String game1TilesInSegment2String =
      '[TileState(row=1, col=4, value=5, isTapped=false), TileState(row=1, col=5, value=4, isTapped=false), TileState(row=1, col=6, value=3, isTapped=false), TileState(row=2, col=4, value=null, isTapped=false), TileState(row=2, col=5, value=null, isTapped=false), TileState(row=2, col=6, value=null, isTapped=false), TileState(row=3, col=4, value=6, isTapped=false), TileState(row=3, col=5, value=null, isTapped=false), TileState(row=3, col=6, value=null, isTapped=false)]';

  static final String game1ValuesStringSolved = '''
-------------------------------------
| 6 | 8 | 2 | 5 | 4 | 3 | 9 | 1 | 7 |
-------------------------------------
| 3 | 4 | 7 | 1 | 9 | 8 | 2 | 6 | 5 |
-------------------------------------
| 9 | 1 | 5 | 6 | 2 | 7 | 4 | 3 | 8 |
-------------------------------------
| 4 | 2 | 3 | 7 | 5 | 1 | 8 | 9 | 6 |
-------------------------------------
| 7 | 5 | 8 | 9 | 6 | 2 | 3 | 4 | 1 |
-------------------------------------
| 1 | 6 | 9 | 3 | 8 | 4 | 7 | 5 | 2 |
-------------------------------------
| 5 | 7 | 6 | 2 | 3 | 9 | 1 | 8 | 4 |
-------------------------------------
| 8 | 3 | 1 | 4 | 7 | 6 | 5 | 2 | 9 |
-------------------------------------
| 2 | 9 | 4 | 8 | 1 | 5 | 6 | 7 | 3 |
-------------------------------------
''';

// Easy one
  static final List<List<int>> game2ValuesList = [
    [null, 2, null, null, null, 7, 3, 5, 6],
    [null, 9, null, 1, 3, null, null, null, 8],
    [3, null, null, 6, null, 8, 9, 2, null],
    [4, null, 9, null, 6, null, 1, null, null],
    [2, null, null, null, null, null, null, null, 3],
    [null, null, 6, null, 4, null, 2, null, 9],
    [null, 5, 3, 7, null, 6, null, null, 4],
    [7, null, null, null, 1, 9, null, 3, null],
    [9, 6, 2, 3, null, null, null, 1, null],
  ];

  static final String game2ValuesListString = '''
-------------------------------------
|   | 2 |   |   |   | 7 | 3 | 5 | 6 |
-------------------------------------
|   | 9 |   | 1 | 3 |   |   |   | 8 |
-------------------------------------
| 3 |   |   | 6 |   | 8 | 9 | 2 |   |
-------------------------------------
| 4 |   | 9 |   | 6 |   | 1 |   |   |
-------------------------------------
| 2 |   |   |   |   |   |   |   | 3 |
-------------------------------------
|   |   | 6 |   | 4 |   | 2 |   | 9 |
-------------------------------------
|   | 5 | 3 | 7 |   | 6 |   |   | 4 |
-------------------------------------
| 7 |   |   |   | 1 | 9 |   | 3 |   |
-------------------------------------
| 9 | 6 | 2 | 3 |   |   |   | 1 |   |
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

  static final String game2ValuesStringSolved = '''
-------------------------------------
| 8 | 2 | 1 | 4 | 9 | 7 | 3 | 5 | 6 |
-------------------------------------
| 6 | 9 | 5 | 1 | 3 | 2 | 7 | 4 | 8 |
-------------------------------------
| 3 | 4 | 7 | 6 | 5 | 8 | 9 | 2 | 1 |
-------------------------------------
| 4 | 7 | 9 | 2 | 6 | 3 | 1 | 8 | 5 |
-------------------------------------
| 2 | 1 | 8 | 9 | 7 | 5 | 4 | 6 | 3 |
-------------------------------------
| 5 | 3 | 6 | 8 | 4 | 1 | 2 | 7 | 9 |
-------------------------------------
| 1 | 5 | 3 | 7 | 2 | 6 | 8 | 9 | 4 |
-------------------------------------
| 7 | 8 | 4 | 5 | 1 | 9 | 6 | 3 | 2 |
-------------------------------------
| 9 | 6 | 2 | 3 | 8 | 4 | 5 | 1 | 7 |
-------------------------------------
''';

  static final List<List<int>> game3ValuesList = [
    [2, null, 7, null, 3, 5, null, null, 4],
    [6, null, 9, null, null, null, null, null, null],
    [null, null, null, null, null, 7, null, null, null],
    [7, null, 4, 9, null, null, 6, null, 8],
    [3, null, null, null, 6, null, null, null, 1],
    [1, null, 5, null, null, 2, 7, null, 9],
    [null, null, null, 8, null, null, null, null, null],
    [null, null, null, null, null, null, 9, null, 5],
    [4, null, null, 5, 2, null, 1, null, 3],
  ];

  static final String game3ValuesStringSolved = '''
-------------------------------------
| 2 | 1 | 7 | 6 | 3 | 5 | 8 | 9 | 4 |
-------------------------------------
| 6 | 4 | 9 | 2 | 1 | 8 | 3 | 5 | 7 |
-------------------------------------
| 5 | 8 | 3 | 4 | 9 | 7 | 2 | 1 | 6 |
-------------------------------------
| 7 | 2 | 4 | 9 | 5 | 1 | 6 | 3 | 8 |
-------------------------------------
| 3 | 9 | 8 | 7 | 6 | 4 | 5 | 2 | 1 |
-------------------------------------
| 1 | 6 | 5 | 3 | 8 | 2 | 7 | 4 | 9 |
-------------------------------------
| 9 | 5 | 1 | 8 | 7 | 3 | 4 | 6 | 2 |
-------------------------------------
| 8 | 3 | 2 | 1 | 4 | 6 | 9 | 7 | 5 |
-------------------------------------
| 4 | 7 | 6 | 5 | 2 | 9 | 1 | 8 | 3 |
-------------------------------------
''';

  static final List<List<int>> game4ValuesList = [
    [3, null, null, 8, null, 1, null, null, 2],
    [2, null, 1, null, 3, null, 6, null, 4],
    [null, null, null, 2, null, 4, null, null, null],
    [8, null, 9, null, null, null, 1, null, 6],
    [null, 6, null, null, null, null, null, 5, null],
    [7, null, 2, null, null, null, 4, null, 9],
    [null, null, null, 5, null, 9, null, null, null],
    [9, null, 4, null, 8, null, 7, null, 5],
    [6, null, null, 1, null, 7, null, null, 3],
  ];

  static final String game4ValuesStringSolved = '''
-------------------------------------
| 3 | 4 | 6 | 8 | 9 | 1 | 5 | 7 | 2 |
-------------------------------------
| 2 | 9 | 1 | 7 | 3 | 5 | 6 | 8 | 4 |
-------------------------------------
| 5 | 7 | 8 | 2 | 6 | 4 | 3 | 9 | 1 |
-------------------------------------
| 8 | 5 | 9 | 4 | 7 | 3 | 1 | 2 | 6 |
-------------------------------------
| 4 | 6 | 3 | 9 | 1 | 2 | 8 | 5 | 7 |
-------------------------------------
| 7 | 1 | 2 | 6 | 5 | 8 | 4 | 3 | 9 |
-------------------------------------
| 1 | 3 | 7 | 5 | 4 | 9 | 2 | 6 | 8 |
-------------------------------------
| 9 | 2 | 4 | 3 | 8 | 6 | 7 | 1 | 5 |
-------------------------------------
| 6 | 8 | 5 | 1 | 2 | 7 | 9 | 4 | 3 |
-------------------------------------
''';

  static final List<List<int>> game5ValuesList = [
    [4, 6, 1, null, null, null, null, 2, null],
    [null, null, null, 1, null, null, 7, null, null],
    [9, null, null, 2, null, 5, null, null, null],
    [null, null, 9, null, 5, 3, null, null, null],
    [6, 5, null, null, null, null, null, 4, 7],
    [null, null, null, 6, 2, null, 1, null, null],
    [null, null, null, 5, null, 4, null, null, 1],
    [null, null, 6, null, null, 2, null, null, null],
    [null, 1, null, null, null, null, 6, 3, 5],
  ];

  static final String game5ValuesStringSolved = '''
-------------------------------------
| 4 | 6 | 1 | 7 | 3 | 9 | 5 | 2 | 8 |
-------------------------------------
| 8 | 2 | 5 | 1 | 4 | 6 | 7 | 9 | 3 |
-------------------------------------
| 9 | 3 | 7 | 2 | 8 | 5 | 4 | 1 | 6 |
-------------------------------------
| 1 | 7 | 9 | 4 | 5 | 3 | 8 | 6 | 2 |
-------------------------------------
| 6 | 5 | 2 | 8 | 9 | 1 | 3 | 4 | 7 |
-------------------------------------
| 3 | 4 | 8 | 6 | 2 | 7 | 1 | 5 | 9 |
-------------------------------------
| 7 | 9 | 3 | 5 | 6 | 4 | 2 | 8 | 1 |
-------------------------------------
| 5 | 8 | 6 | 3 | 1 | 2 | 9 | 7 | 4 |
-------------------------------------
| 2 | 1 | 4 | 9 | 7 | 8 | 6 | 3 | 5 |
-------------------------------------
''';

  static final List<List<int>> game6ValuesList = [
    [3, null, 1, null, null, 8, null, null, null],
    [null, null, null, null, null, null, null, 7, null],
    [7, null, null, 5, 4, null, 1, 2, null],
    [9, 8, null, null, null, null, null, null, null],
    [5, 7, null, 1, null, 2, null, 8, 9],
    [null, null, null, null, null, null, null, 4, 2],
    [null, 3, 7, null, 2, 9, null, null, 1],
    [null, 4, null, null, null, null, null, null, null],
    [null, null, null, 7, null, null, 9, null, 4],
  ];

  static final String game6ValuesStringSolved = '''
-------------------------------------
| 3 | 5 | 1 | 2 | 7 | 8 | 4 | 9 | 6 |
-------------------------------------
| 4 | 2 | 8 | 9 | 6 | 1 | 3 | 7 | 5 |
-------------------------------------
| 7 | 9 | 6 | 5 | 4 | 3 | 1 | 2 | 8 |
-------------------------------------
| 9 | 8 | 2 | 6 | 5 | 4 | 7 | 1 | 3 |
-------------------------------------
| 5 | 7 | 4 | 1 | 3 | 2 | 6 | 8 | 9 |
-------------------------------------
| 1 | 6 | 3 | 8 | 9 | 7 | 5 | 4 | 2 |
-------------------------------------
| 6 | 3 | 7 | 4 | 2 | 9 | 8 | 5 | 1 |
-------------------------------------
| 8 | 4 | 9 | 3 | 1 | 5 | 2 | 6 | 7 |
-------------------------------------
| 2 | 1 | 5 | 7 | 8 | 6 | 9 | 3 | 4 |
-------------------------------------
''';

  static final List<List<int>> game7ValuesList = [
    [null, null, 8, 6, null, null, null, null, 9],
    [4, 7, null, 3, null, null, null, null, null],
    [null, null, null, null, null, null, 4, 1, 3],
    [null, null, null, null, 8, 4, 7, null, null],
    [7, null, null, 1, null, 6, null, null, 2],
    [null, null, 6, 7, 9, null, null, null, null],
    [1, 9, 7, null, null, null, null, null, null],
    [null, null, null, null, null, 3, null, 2, 7],
    [2, null, null, null, null, 1, 8, null, null],
  ];

  static final String game7ValuesStringSolved = '''
-------------------------------------
| 3 | 1 | 8 | 6 | 4 | 5 | 2 | 7 | 9 |
-------------------------------------
| 4 | 7 | 2 | 3 | 1 | 9 | 6 | 5 | 8 |
-------------------------------------
| 6 | 5 | 9 | 8 | 2 | 7 | 4 | 1 | 3 |
-------------------------------------
| 9 | 2 | 1 | 5 | 8 | 4 | 7 | 3 | 6 |
-------------------------------------
| 7 | 4 | 5 | 1 | 3 | 6 | 9 | 8 | 2 |
-------------------------------------
| 8 | 3 | 6 | 7 | 9 | 2 | 5 | 4 | 1 |
-------------------------------------
| 1 | 9 | 7 | 2 | 5 | 8 | 3 | 6 | 4 |
-------------------------------------
| 5 | 8 | 4 | 9 | 6 | 3 | 1 | 2 | 7 |
-------------------------------------
| 2 | 6 | 3 | 4 | 7 | 1 | 8 | 9 | 5 |
-------------------------------------
''';

  static final List<List<int>> game8ValuesList = [
    [null, null, null, null, null, null, null, null, null],
    [null, null, null, null, 3, 7, null, null, 5],
    [6, 9, null, null, null, null, null, 2, null],
    [null, null, null, null, null, null, null, 6, null],
    [null, null, null, null, null, null, 3, 4, 2],
    [null, null, null, 6, null, 9, 5, null, null],
    [8, 3, null, null, null, null, null, null, null],
    [null, null, 2, 9, null, 1, null, 7, null],
    [null, 1, 4, null, 8, null, null, null, null],
  ];

  static final String game8ValuesStringSolved = '''
-------------------------------------
| 1 | 5 | 7 | 2 | 9 | 6 | 4 | 3 | 8 |
-------------------------------------
| 4 | 2 | 8 | 1 | 3 | 7 | 6 | 9 | 5 |
-------------------------------------
| 6 | 9 | 3 | 8 | 5 | 4 | 7 | 2 | 1 |
-------------------------------------
| 2 | 8 | 5 | 4 | 7 | 3 | 1 | 6 | 9 |
-------------------------------------
| 9 | 7 | 6 | 5 | 1 | 8 | 3 | 4 | 2 |
-------------------------------------
| 3 | 4 | 1 | 6 | 2 | 9 | 5 | 8 | 7 |
-------------------------------------
| 8 | 3 | 9 | 7 | 6 | 5 | 2 | 1 | 4 |
-------------------------------------
| 5 | 6 | 2 | 9 | 4 | 1 | 8 | 7 | 3 |
-------------------------------------
| 7 | 1 | 4 | 3 | 8 | 2 | 9 | 5 | 6 |
-------------------------------------
''';

  static final List<List<int>> game9ValuesList = [
    [3, null, null, null, null, 9, null, null, 5],
    [null, null, 2, 7, null, 1, null, null, 6],
    [null, null, null, null, null, 2, 9, null, null],
    [2, null, 6, null, null, null, null, 5, null],
    [null, 4, 3, null, null, null, 2, 8, null],
    [null, 9, null, null, null, null, 4, null, 1],
    [null, null, 9, 1, null, null, null, null, null],
    [4, null, null, 3, null, 8, 6, null, null],
    [8, null, null, 4, null, null, null, null, 3],
  ];

  static final String game9ValuesStringSolved = '''
-------------------------------------
| 3 | 1 | 4 | 8 | 6 | 9 | 7 | 2 | 5 |
-------------------------------------
| 9 | 5 | 2 | 7 | 4 | 1 | 8 | 3 | 6 |
-------------------------------------
| 7 | 6 | 8 | 5 | 3 | 2 | 9 | 1 | 4 |
-------------------------------------
| 2 | 8 | 6 | 9 | 1 | 4 | 3 | 5 | 7 |
-------------------------------------
| 1 | 4 | 3 | 6 | 7 | 5 | 2 | 8 | 9 |
-------------------------------------
| 5 | 9 | 7 | 2 | 8 | 3 | 4 | 6 | 1 |
-------------------------------------
| 6 | 3 | 9 | 1 | 2 | 7 | 5 | 4 | 8 |
-------------------------------------
| 4 | 7 | 1 | 3 | 5 | 8 | 6 | 9 | 2 |
-------------------------------------
| 8 | 2 | 5 | 4 | 9 | 6 | 1 | 7 | 3 |
-------------------------------------
''';

  static final List<List<List<int>>> games = [
    game0ValuesList,
    game1ValuesList,
    game2ValuesList,
    game3ValuesList,
    game4ValuesList,
    game5ValuesList,
    game6ValuesList,
    game7ValuesList,
    game8ValuesList,
    game9ValuesList,
  ];

  static final List<String> solvedGames = [
    game0ValuesStringSolved,
    game1ValuesStringSolved,
    game2ValuesStringSolved,
    game3ValuesStringSolved,
    game4ValuesStringSolved,
    game5ValuesStringSolved,
    game6ValuesStringSolved,
    game7ValuesStringSolved,
    game8ValuesStringSolved,
    game9ValuesStringSolved,
  ];
}
