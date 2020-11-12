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

  TicTacToeGame() {
    _cells.fillRange(0, _cells.length, _CellType.Empty);
    _current = _CellType.X;
    _winner = _checkForWinner();
    _moreMoves = _checkForMoreMoves();
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

  Widget _renderCell(int row, int col, {Function(int, int) onPressed}) =>
      ElevatedButton(
        child: Text(
          _cellToString[_cellAt(col, row)],
          textScaleFactor: 3.0,
        ),
        onPressed: () => onPressed(col, row),
      );

  Widget _renderRow(int row, {Function(int, int) onPressed}) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Spacer(flex: 9),
          _renderCell(row, 0, onPressed: onPressed),
          //Spacer(flex: 1),
          _renderCell(row, 1, onPressed: onPressed),
          //Spacer(flex: 1),
          _renderCell(row, 2, onPressed: onPressed),
          //Spacer(flex: 9)
        ],
      );

  Widget renderBoard({Function(int, int) onPressed}) {
    if (_winner != _CellType.Empty) {
      return Text("Winner is ${_cellToString[_winner]}", textScaleFactor: 2.0);
    }

    // No one has won, but no more moves can be made, so it's a draw.
    if (!_moreMoves) {
      return Text("It's a draw!", textScaleFactor: 2.0);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
//        Spacer(flex: 9),
        _renderRow(0, onPressed: onPressed),
//        Spacer(flex: 1),
        _renderRow(1, onPressed: onPressed),
//        Spacer(flex: 1),
        _renderRow(2, onPressed: onPressed),
//        Spacer(flex: 9)
      ],
    );
  }
}

class SuperTicTacToeGame {
  final _games = List<TicTacToeGame>(9);

  SuperTicTacToeGame() {
    for (var i = 0; i < _games.length; i++) _games[i] = TicTacToeGame();
  }

  Widget _renderGame(int row, int col,
          {Function(TicTacToeGame, int, int) onPressed}) =>
      _games[row * 3 + col].renderBoard(
        onPressed: (gameRow, gameCol) =>
            onPressed(_games[row * 3 + col], gameRow, gameCol),
      );

  Widget _renderRowOfGames(int row,
          {Function(TicTacToeGame, int, int) onPressed}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Spacer(flex: 9),
          _renderGame(row, 0, onPressed: onPressed),
          Spacer(flex: 1),
          _renderGame(row, 1, onPressed: onPressed),
          Spacer(flex: 1),
          _renderGame(row, 2, onPressed: onPressed),
          Spacer(flex: 9)
        ],
      );

  Widget renderBoard({Function(TicTacToeGame, int, int) onPressed}) {
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
        Spacer(flex: 9),
        _renderRowOfGames(0, onPressed: onPressed),
        Spacer(flex: 1),
        _renderRowOfGames(1, onPressed: onPressed),
        Spacer(flex: 1),
        _renderRowOfGames(2, onPressed: onPressed),
        Spacer(flex: 9)
      ],
    );
  }
}
