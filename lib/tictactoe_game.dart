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
  final _boardCells = List<_CellType>(9);
  var _currentPlayer = _CellType.X;
  var _winner = _CellType.Empty;
  var _moreMoves = true;
  var _lastCellX = -1;
  var _lastCellY = -1;

  get lastCellX => _lastCellX;
  get lastCellY => _lastCellY;
  get currentPlayer => _currentPlayer;

  TicTacToeGame() {
    _boardCells.fillRange(0, _boardCells.length, _CellType.Empty);
    _currentPlayer = _CellType.X;
    _winner = _checkForWinner();
    _moreMoves = _checkForMoreMoves();
    _lastCellX = -1;
    _lastCellY = -1;
  }

  _CellType _cellAt(int x, int y) {
    var index = y * 3 + x;
    assert(index >= 0 && index < _boardCells.length);
    return _boardCells[index];
  }

  void move(int x, int y, {_CellType current = _CellType.Empty}) {
    assert(_winner == _CellType.Empty);
    final index = y * 3 + x;
    assert(index >= 0 && index < _boardCells.length);
    assert(_boardCells[index] == _CellType.Empty);
    if (current != _CellType.Empty) {
      _currentPlayer = current;
    }
    _boardCells[index] = _currentPlayer;
    _currentPlayer = _currentPlayer == _CellType.O ? _CellType.X : _CellType.O;
    _winner = _checkForWinner();
    _moreMoves = _checkForMoreMoves();
    _lastCellX = x;
    _lastCellY = y;
  }

  bool _checkForMoreMoves() => _boardCells.contains(_CellType.Empty);

  _CellType _checkForWinSequence(int x, int y, int dx, int dy) {
    var prevCell = _CellType.Empty;
    for (int i = 0; i < 3; i++) {
      final index = (y + dy * i) * 3 + x + dx * i;
      assert(index >= 0 && index < 9);
      final cell = _boardCells[index];
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
    var msg = _cellToString[_winner];
    if (_winner == _CellType.Empty) {
      msg = _moreMoves ? '' : '#';
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
  final _boards = List<TicTacToeGame>(9);
  var _lastBoardX = -1;
  var _lastBoardY = -1;
  var _current = _CellType.X;

  get current => _current;

  SuperTicTacToeGame() {
    for (var i = 0; i < _boards.length; i++) _boards[i] = TicTacToeGame();
    _lastBoardX = -1;
    _lastBoardY = -1;
    _current = _CellType.X;
  }

  Widget _renderBoard(int boardX, int boardY,
      {Function(TicTacToeGame, int, int) onPressed}) {
    // Check if the current (this) board can be played, e.g.
    // if more moves are possible, and no winner.
    final thisBoard = _boards[boardY * 3 + boardX];
    var enabled = thisBoard._moreMoves && thisBoard._winner == _CellType.Empty;
    if (enabled && _lastBoardX != -1) {
      assert(_lastBoardX >= 0 && _lastBoardX < 3);
      assert(_lastBoardY >= 0 && _lastBoardY < 3);
      final lastBoard = _boards[_lastBoardY * 3 + _lastBoardX];
      final nextBoardX = lastBoard.lastCellX;
      final nextBoardY = lastBoard.lastCellY;
      assert(nextBoardX >= 0 && nextBoardX < 3);
      assert(nextBoardY >= 0 && nextBoardY < 3);
      // Find the next board that should be played.
      final nextBoard = _boards[nextBoardY * 3 + nextBoardX];
      // Check if the next board is playable If the next board is playable (e.g. more moves possible, no winner)
      // Then enable only it, and disable the rest, otherwise enable them.
      if (nextBoard._moreMoves && nextBoard._winner == _CellType.Empty) {
        enabled = (nextBoardX == boardX && nextBoardY == boardY);
      }
    }
    return thisBoard.renderBoard(
        onPressed: (gameRow, gameCol) {
          onPressed(thisBoard, gameRow, gameCol);
          _lastBoardX = boardX;
          _lastBoardY = boardY;
          _current = thisBoard.currentPlayer;
        },
        disabled: !enabled);
  }

  Widget _renderBoardsRow(int row,
          {Function(TicTacToeGame, int, int) onPressed}) =>
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _renderBoard(0, row, onPressed: onPressed),
          _renderBoard(1, row, onPressed: onPressed),
          _renderBoard(2, row, onPressed: onPressed),
        ],
      );

  Widget renderBoard({Function(TicTacToeGame, int, int) onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _renderBoardsRow(0, onPressed: onPressed),
        _renderBoardsRow(1, onPressed: onPressed),
        _renderBoardsRow(2, onPressed: onPressed),
      ],
    );
  }
}
