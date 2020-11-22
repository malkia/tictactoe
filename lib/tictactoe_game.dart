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

const _winningSequencesChecks = [
  [0, 0, 0, 1],
  [1, 0, 0, 1],
  [2, 0, 0, 1],
  [0, 0, 1, 0],
  [0, 1, 1, 0],
  [0, 2, 1, 0],
  [0, 0, 1, 1],
  [0, 2, 1, -1],
];

abstract class _TicTacToeBoard {
  _CellType cellAt(int x, int y);
}

_CellType _checkForWinningSequence(
    _TicTacToeBoard board, int startX, int startY, int deltaX, int deltaY,
    [count = 3]) {
  final firstCell = board.cellAt(startX, startY);
  if (firstCell != _CellType.Empty) {
    for (var i = 1; i < count; i++) {
      final cell = board.cellAt(startX + i * deltaX, startY + i * deltaY);
      if (firstCell != cell) {
        return _CellType.Empty;
      }
    }
  }
  return firstCell;
}

_CellType _checkForWinner(_TicTacToeBoard board) {
  for (var c in _winningSequencesChecks) {
    final cell = _checkForWinningSequence(board, c[0], c[1], c[2], c[3]);
    if (cell != _CellType.Empty) {
      return cell;
    }
  }
  return _CellType.Empty;
}

bool _checkForMoreMoves(_TicTacToeBoard board, [count = 3]) {
  for (var y = 0; y < count; y++)
    for (var x = 0; x < count; x++)
      if (board.cellAt(x, y) == _CellType.Empty) {
        return true;
      }
  return false;
}

class TicTacToeGame implements _TicTacToeBoard {
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
    _winner = _checkForWinner(this);
    _moreMoves = _checkForMoreMoves(this);
    _lastCellX = -1;
    _lastCellY = -1;
  }

  _CellType cellAt(int x, int y) {
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
    _winner = _checkForWinner(this);
    _moreMoves = _checkForMoreMoves(this);
    _lastCellX = x;
    _lastCellY = y;
  }

  Widget _renderCell(int col, int row,
      {Function(int, int) onPressed, bool disabled = false}) {
    var cell = cellAt(col, row);
    if (cell != _CellType.Empty) disabled = true;
    if (!disabled) disabled = !_moreMoves || _winner != _CellType.Empty;
    return Padding(
      padding: EdgeInsets.all(0.5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(40, 40),
          visualDensity: VisualDensity.compact,
        ),
        child: Text(_cellToString[cell]),
        onPressed: disabled ? null : () => onPressed(col, row),
      ),
    );
  }

  Widget renderBoard(BuildContext context,
      {Function(int, int) onPressed, bool disabled = false}) {
    var msg = _cellToString[_winner];
    if (_winner == _CellType.Empty) {
      msg = _moreMoves ? '' : '#';
    }
    return Padding(
        padding: EdgeInsets.all(2),
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Column(mainAxisSize: MainAxisSize.min, children: [
              for (var row = 0; row < 3; row++)
                Row(mainAxisSize: MainAxisSize.min, children: [
                  for (var col = 0; col < 3; col++)
                    _renderCell(col, row,
                        onPressed: onPressed, disabled: disabled)
                ]),
            ]),
            if (msg != '')
              Text(
                msg,
                textScaleFactor: 5.0,
              ),
          ],
        ));
  }
}

class SuperTicTacToeGame implements _TicTacToeBoard {
  final _boards = List<TicTacToeGame>(9);
  var _lastBoardX = -1;
  var _lastBoardY = -1;
  var _current = _CellType.X;

  get current => _current;

  _CellType cellAt(int x, int y) {
    assert(x >= 0 && x < 3);
    assert(y >= 0 && y < 3);
    return _boards[y * 3 + x]._winner;
  }

  SuperTicTacToeGame() {
    for (var i = 0; i < _boards.length; i++) {
      _boards[i] = TicTacToeGame();
    }
    _lastBoardX = -1;
    _lastBoardY = -1;
    _current = _CellType.X;
  }

  Widget _renderBoard(BuildContext context, int boardX, int boardY,
      {Function(TicTacToeGame, int, int) onPressed, bool disabled = false}) {
    // Check if the current (this) board can be played, e.g.
    // if more moves are possible, and no winner.
    final thisBoard = _boards[boardY * 3 + boardX];
    var enabled = !disabled &&
        thisBoard._moreMoves &&
        thisBoard._winner == _CellType.Empty;
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
      // Check if the next board is playable (e.g. moves are possible, but no winner)
      // Then enable only it, and disable the rest, otherwise enable them.
      if (nextBoard._moreMoves && nextBoard._winner == _CellType.Empty) {
        enabled = (nextBoardX == boardX && nextBoardY == boardY);
      }
    }
    return thisBoard.renderBoard(context, onPressed: (gameRow, gameCol) {
      onPressed(thisBoard, gameRow, gameCol);
      _lastBoardX = boardX;
      _lastBoardY = boardY;
      _current = thisBoard.currentPlayer;
    }, disabled: !enabled);
  }

  Widget renderBoard(BuildContext context,
      {Function(TicTacToeGame, int, int) onPressed}) {
    var moreMoves = _checkForMoreMoves(this);
    var winner = _checkForWinner(this);
    var disabled = !moreMoves || winner != _CellType.Empty;
    var msg = _cellToString[winner];
    if (winner == _CellType.Empty) {
      msg = moreMoves ? '' : '#';
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(disabled ? "" : "It's ${_cellToString[_current]} turn"),
        Stack(alignment: AlignmentDirectional.center, children: [
          Column(mainAxisSize: MainAxisSize.min, children: [
            for (var row = 0; row < 3; row++)
              Row(mainAxisSize: MainAxisSize.min, children: [
                for (var col = 0; col < 3; col++)
                  _renderBoard(context, col, row,
                      onPressed: onPressed, disabled: disabled)
              ])
          ]),
          if (disabled)
            Text(
              msg,
              style: TextStyle(color: Colors.red),
              textScaleFactor: 20.0,
            )
        ])
      ],
    );
  }
}
