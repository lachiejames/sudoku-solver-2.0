/// Stores 2d array representation of sudokus, used on JustPlayScreen
library my_games;

final List<List<int>> _game0ValuesList = [
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

final List<List<int>> _game1ValuesList = [
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

final List<List<int>> _game2ValuesList = [
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

final List<List<int>> _game3ValuesList = [
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

final List<List<int>> _game4ValuesList = [
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

final List<List<int>> _game5ValuesList = [
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

final List<List<int>> _game6ValuesList = [
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

final List<List<int>> _game7ValuesList = [
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

final List<List<int>> _game8ValuesList = [
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

final List<List<int>> _game9ValuesList = [
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

final List<List<List<int>>> games = [
  _game0ValuesList,
  _game1ValuesList,
  _game2ValuesList,
  _game3ValuesList,
  _game4ValuesList,
  _game5ValuesList,
  _game6ValuesList,
  _game7ValuesList,
  _game8ValuesList,
  _game9ValuesList,
];

final List<List<int>> solvingTimeoutErrorGame = [
  [null, null, null, 7, null, null, null, null, null],
  [1, null, null, null, null, null, null, null, null],
  [null, null, null, 4, 3, null, 2, null, null],
  [null, null, null, null, null, null, null, null, 6],
  [null, null, null, 5, null, 9, null, null, null],
  [null, null, null, null, null, null, 4, 1, 8],
  [null, null, null, null, 8, 1, null, null, null],
  [null, null, 2, null, null, null, null, 5, null],
  [null, 4, null, null, null, null, 3, null, null],
];

final List<List<int>> solvingInvalidErrorGame = [
  [5, 1, 6, 8, 4, 9, 7, 3, 2],
  [3, null, 7, 6, null, 5, null, null, null],
  [8, null, 9, 7, null, null, null, 6, 5],
  [1, 3, 5, null, 6, null, 9, null, 7],
  [4, 7, 2, 5, 9, 1, null, null, 6],
  [9, 6, 8, 3, 7, null, null, 5, null],
  [2, 5, 3, 1, 8, 6, null, 7, 4],
  [6, 8, 4, 2, null, 7, 5, null, null],
  [7, 9, 1, null, 5, null, 6, null, 8],
];
