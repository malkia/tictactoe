import 'package:flutter/material.dart';

// Great article, and the first one that I remember learning about it
// https://mathwithbaddrawings.com/2013/06/16/ultimate-tic-tac-toe/

// Some game options from the article above:
//  Tie (draw) on the larger board can be considered as both X and O

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
  get current => _current;

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

  void move(int x, int y, {_CellType current = _CellType.Empty}) {
    assert(_winner == _CellType.Empty);
    final index = y * 3 + x;
    assert(index >= 0 && index < _cells.length);
    assert(_cells[index] == _CellType.Empty);
    if (current != _CellType.Empty) {
      _current = current;
    }
    _cells[index] = _current;
    _current = _current == _CellType.O ? _CellType.X : _CellType.O;
    _winner = _checkForWinner();
    _moreMoves = _checkForMoreMoves();
    _lastX = x;
    _lastY = y;
  }

  bool _checkForMoreMoves() => _cells.contains(_CellType.Empty);

  _CellType _checkForWinSequence(int x, int y, int dx, int dy) {
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

  _CellType _checkForWinner() {
    for (var c in _checksForWin) {
      final cell = _checkForWinSequence(c[0], c[1], c[2], c[3]);
      if (cell != _CellType.Empty) {
        return cell;
      }
    }
    return _CellType.Empty;
  }

  Widget _renderCell(int col, int row,
      {Function(int, int) onPressed, bool disabled = false}) {
    var cell = _cellAt(col, row);
    if (cell != _CellType.Empty) disabled = true;
    return Padding(
      padding: EdgeInsets.all(1.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(40, 40),
        ),
        child: Text(_cellToString[cell]),
        onPressed: disabled ? null : () => onPressed(col, row),
      ),
    );
  }

  Widget _renderRow(int row,
          {Function(int, int) onPressed, bool disabled = false}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _renderCell(0, row, onPressed: onPressed, disabled: disabled),
          _renderCell(1, row, onPressed: onPressed, disabled: disabled),
          _renderCell(2, row, onPressed: onPressed, disabled: disabled),
        ],
      );

  Widget renderBoard({Function(int, int) onPressed, bool disabled = false}) {
    var msg = '';

    if (_winner == _CellType.X) {
      msg = 'X';
    } else if (_winner == _CellType.O) {
      msg = 'O';
    } else if (!_moreMoves) {
      msg = '#';
    }

    return Padding(
        padding: EdgeInsets.all(4),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _renderRow(0, onPressed: onPressed, disabled: disabled),
                _renderRow(1, onPressed: onPressed, disabled: disabled),
                _renderRow(2, onPressed: onPressed, disabled: disabled),
              ],
            ),
            Text(msg, textScaleFactor: 5.0),
          ],
        ));
  }
}

class SuperTicTacToeGame {
  final _games = List<TicTacToeGame>(9);
  var _lastX = -1;
  var _lastY = -1;
  var _current = _CellType.X;

  get current => _current;

  SuperTicTacToeGame() {
    for (var i = 0; i < _games.length; i++) _games[i] = TicTacToeGame();
    _lastX = -1;
    _lastY = -1;
    _current = _CellType.X;
  }

  Widget _renderGame(int col, int row,
      {Function(TicTacToeGame, int, int) onPressed}) {
    var enabled = true;
    if (_lastX != -1) {
      var lastGame = _games[_lastY * 3 + _lastX];
      if (lastGame._moreMoves && lastGame._winner == _CellType.Empty) {
        var nextGame = _games[lastGame.lastY * 3 + lastGame.lastX];
        if (nextGame._moreMoves && nextGame._winner == _CellType.Empty) {
          enabled = (lastGame.lastX == col && lastGame.lastY == row);
        }
      }
    }
    var game = _games[row * 3 + col];
    if (!game._moreMoves || game._winner != _CellType.Empty) {
      enabled = false;
    }
    return game.renderBoard(
        onPressed: (gameRow, gameCol) {
          onPressed(game, gameRow, gameCol);
          _lastX = col;
          _lastY = row;
          _current = game.current;
        },
        disabled: !enabled);
  }

  Widget _renderRowOfGames(int row,
          {Function(TicTacToeGame, int, int) onPressed}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
//          Spacer(),
          _renderGame(0, row, onPressed: onPressed),
          _renderGame(1, row, onPressed: onPressed),
          _renderGame(2, row, onPressed: onPressed),
//          Spacer(),
        ],
      );

  Widget renderBoard({Function(TicTacToeGame, int, int) onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //      Spacer(),
        _renderRowOfGames(0, onPressed: onPressed),
        _renderRowOfGames(1, onPressed: onPressed),
        _renderRowOfGames(2, onPressed: onPressed),
//        Spacer(),
      ],
    );
  }
}
