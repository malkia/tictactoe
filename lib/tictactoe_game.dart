import 'package:flutter/material.dart';

enum _CellType { Empty, X, O }

const _cellToString = {
  _CellType.Empty: ' ',
  _CellType.X: 'X',
  _CellType.O: 'O',
};

const _checksForWin = [
  [0, 0, 0, 1],
  [1, 0, 0, 1],
  [2, 0, 0, 1],
  [0, 0, 1, 0],
  [0, 1, 1, 0],
  [0, 2, 1, 0],
  [0, 0, 1, 1],
  [0, 2, 1, -1],
];

class TicTacToeGame {
  final _cells = List<_CellType>(9);
  var _current = _CellType.X;
  var _winner = _CellType.Empty;
  var _moreMoves = true;
  var _lastX = -1;
  var _lastY = -1;

  get lastX => _lastX;
  get lastY => _lastY;

  TicTacToeGame() {
    _cells.fillRange(0, _cells.length, _CellType.Empty);
    _current = _CellType.X;
    _winner = _checkForWinner();
    _moreMoves = _checkForMoreMoves();
    _lastX = -1;
    _lastY = -1;
  }

  _CellType _cellAt(int x, int y) {
    var index = y * 3 + x;
    assert(index >= 0 && index < _cells.length);
    return _cells[index];
  }

  bool move(int x, int y) {
    final index = y * 3 + x;
    assert(index >= 0 && index < _cells.length);
    if (_cells[index] != _CellType.Empty) {
      return false;
    }
    _cells[index] = _current;
    _current = _current == _CellType.O ? _CellType.X : _CellType.O;
    _winner = _checkForWinner();
    _moreMoves = _checkForMoreMoves();
    _lastX = x;
    _lastY = y;
    return true;
  }

  _CellType _checkThreeNeighbours(int x, int y, int dx, int dy) {
    var prevCell = _CellType.Empty;
    for (int i = 0; i < 3; i++) {
      final index = (y + dy * i) * 3 + x + dx * i;
      assert(index >= 0 && index < 9);
      final cell = _cells[index];
      if (i > 0 && (cell == _CellType.Empty || prevCell != cell)) {
        return _CellType.Empty;
      }
      prevCell = cell;
    }
    return prevCell;
  }

  bool _checkForMoreMoves() => _cells.contains(_CellType.Empty);

  _CellType _checkForWinner() {
    for (var c in _checksForWin) {
      final cell = _checkThreeNeighbours(c[0], c[1], c[2], c[3]);
      if (cell != _CellType.Empty) {
        return cell;
      }
    }
    return _CellType.Empty;
  }

  Widget _renderCell(int col, int row,
      {Function<bool>(int, int) onPressed, bool disabled = false}) {
    var cell = _cellAt(col, row);
    if (cell != _CellType.Empty) disabled = true;
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: ElevatedButton(
        child: Text(_cellToString[cell]),
        onPressed: disabled ? null : () => onPressed(col, row),
      ),
    );
  }

  Widget _renderRow(int row,
          {Function<bool>(int, int) onPressed, bool disabled = false}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _renderCell(0, row, onPressed: onPressed, disabled: disabled),
          _renderCell(1, row, onPressed: onPressed, disabled: disabled),
          _renderCell(2, row, onPressed: onPressed, disabled: disabled),
        ],
      );

  Widget renderBoard(
      {Function<bool>(int, int) onPressed, bool disabled = false}) {
    var stackIndex = 0;

    if (_winner != _CellType.Empty) {
      stackIndex = 1;
    } else if (!_moreMoves) {
      stackIndex = 2;
    }

    return IndexedStack(
      alignment: AlignmentDirectional.center,
      index: stackIndex,
      children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text("$_lastX $_lastY"),
          _renderRow(0, onPressed: onPressed, disabled: disabled),
          _renderRow(1, onPressed: onPressed, disabled: disabled),
          _renderRow(2, onPressed: onPressed, disabled: disabled),
        ]),
        Text("Winner is ${_cellToString[_winner]}", textScaleFactor: 2.0),
        Text("It's a draw!", textScaleFactor: 2.0),
      ],
    );
  }
}

class SuperTicTacToeGame {
  final _games = List<TicTacToeGame>(9);
  var _lastX = -1;
  var _lastY = -1;

  SuperTicTacToeGame() {
    for (var i = 0; i < _games.length; i++) _games[i] = TicTacToeGame();
    _lastX = -1;
    _lastY = -1;
  }

  Widget _renderGame(int col, int row,
      {Function<bool>(TicTacToeGame, int, int) onPressed}) {
    var disabled = false;
    if (_lastX != -1 && _lastY != -1) {
      var _lastGame = _games[_lastY * 3 + _lastX];
      if (_lastGame.lastX != -1 && _lastGame.lastY != -1) {
        disabled = true;
        if (_lastGame.lastX == col && _lastGame.lastY == row) {
          disabled = false;
          // TODO: Avoid all being disabled if there are still more to be played
        }
      }
    }
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: _games[row * 3 + col].renderBoard(
          onPressed: <bool>(gameRow, gameCol) {
            print("renderGame: $_lastX $_lastY");
            if (onPressed(_games[row * 3 + col], gameRow, gameCol)) {
              _lastX = col;
              _lastY = row;
              return true;
            }
            return false;
          },
          disabled: disabled),
    );
  }

  Widget _renderRowOfGames(int row,
          {Function<bool>(TicTacToeGame, int, int) onPressed}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _renderGame(0, row, onPressed: onPressed),
          _renderGame(1, row, onPressed: onPressed),
          _renderGame(2, row, onPressed: onPressed),
        ],
      );

  Widget renderBoard({Function<bool>(TicTacToeGame, int, int) onPressed}) {
    // if (_winner != _CellType.Empty) {
    //   return Text("The winner is ${_cellToString[_winner]}",
    //       textScaleFactor: 4.0);
    // }

    // // No one has won, but no more moves can be made, so it's a draw.
    // if (!_moreMoves) {
    //   return Text("It's a draw!", textScaleFactor: 4.0);
    // }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("$_lastX $_lastY"),
        _renderRowOfGames(0, onPressed: onPressed),
        _renderRowOfGames(1, onPressed: onPressed),
        _renderRowOfGames(2, onPressed: onPressed),
      ],
    );
  }
}
