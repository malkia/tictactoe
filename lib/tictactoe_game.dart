import 'dart:math';
import 'package:flutter/material.dart';

// Great article, and the first one that I remember learning about it
// https://mathwithbaddrawings.com/2013/06/16/ultimate-tic-tac-toe/

// Some game options from the article above:
//  Tie (draw) on the larger board can be considered as both X and O

enum _State { Empty, X, O, Tie }

const _stateToString = {
  _State.Empty: '',
  _State.X: 'X',
  _State.O: 'O',
  _State.Tie: '#',
};

abstract class _TicTacToeBoard {
  _State cellAt(int x, int y);

  static const _winningSequencesChecks = [
    [0, 0, 0, 1],
    [1, 0, 0, 1],
    [2, 0, 0, 1],
    [0, 0, 1, 0],
    [0, 1, 1, 0],
    [0, 2, 1, 0],
    [0, 0, 1, 1],
    [0, 2, 1, -1],
  ];

  _State _checkForWinningSequence(int x, int y, int dx, int dy) {
    var firstCell = _State.Empty;
    for (var i = 0; i < 3; i++, x += dx, y += dy) {
      final cell = cellAt(x, y);
      if (i == 0) {
        firstCell = cell;
      } else if (firstCell != cell) {
        return _State.Empty;
      }
    }
    return firstCell;
  }

// TODO: We should instead return a list of the indices to the winning sequences
// Then we can have some fancy drawing code show them.
  _State checkForWinner() {
    for (final c in _winningSequencesChecks) {
      final cell = _checkForWinningSequence(c[0], c[1], c[2], c[3]);
      if (cell != _State.Empty) {
        return cell;
      }
    }
    return _checkForMoreMoves() ? _State.Empty : _State.Tie;
  }

  bool _checkForMoreMoves() {
    for (var y = 0; y < 3; y++)
      for (var x = 0; x < 3; x++)
        if (cellAt(x, y) == _State.Empty) {
          return true;
        }
    return false;
  }
}

final _maximizedElevatedButtonStyle = ElevatedButton.styleFrom(
  minimumSize: const Size(double.infinity, double.infinity),
);

class TicTacToeGame extends _TicTacToeBoard {
  final _boardCells = [
    for (var i = 0; i < 9; i++) _State.Empty,
  ];
  var _currentPlayer = _State.X;
  var _winner = _State.Empty;
  var _lastCellX = -1;
  var _lastCellY = -1;

  get lastCellX => _lastCellX;
  get lastCellY => _lastCellY;
  get currentPlayer => _currentPlayer;

  TicTacToeGame() {
    _winner = checkForWinner();
  }

  _State cellAt(int x, int y) {
    assert(x >= 0 && x < 3);
    assert(y >= 0 && y < 3);
    return _boardCells[y * 3 + x];
  }

  void move(int x, int y, {_State current = _State.Empty}) {
    assert(_winner == _State.Empty);
    assert(x >= 0 && x < 3);
    assert(y >= 0 && y < 3);
    final index = y * 3 + x;
    assert(_boardCells[index] == _State.Empty);
    if (current != _State.Empty) {
      _currentPlayer = current;
    }
    _boardCells[index] = _currentPlayer;
    _currentPlayer = _currentPlayer == _State.O ? _State.X : _State.O;
    _winner = checkForWinner();
    _lastCellX = x;
    _lastCellY = y;
  }

  Widget _renderCell(int col, int row,
      {Function(int, int) onPressed, bool disabled = false, size}) {
    final cell = cellAt(col, row);
    if (cell != _State.Empty) {
      disabled = true;
    } else if (!disabled) {
      disabled = _winner != _State.Empty;
    }
    return Padding(
      padding: const EdgeInsets.all(2),
      child: ElevatedButton(
        style: _maximizedElevatedButtonStyle,
        child: Text(_stateToString[cell], textScaleFactor: size / 30),
        onPressed: disabled ? null : () => onPressed(col, row),
      ),
    );
  }

  Widget renderBoard(BuildContext context,
          {Function(int, int) onPressed, bool disabled = false, size}) =>
      Padding(
          padding: const EdgeInsets.all(4),
          child: Stack(alignment: AlignmentDirectional.center, children: [
            Column(mainAxisSize: MainAxisSize.min, children: [
              for (var row = 0; row < 3; row++)
                Expanded(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    for (var col = 0; col < 3; col++)
                      Expanded(
                        child: _renderCell(col, row,
                            onPressed: onPressed,
                            disabled: disabled,
                            size: size),
                      )
                  ]),
                )
            ]),
            if (_winner != _State.Empty)
              Text(_stateToString[_winner], textScaleFactor: size / 10.0)
          ]));
}

class SuperTicTacToeGame extends _TicTacToeBoard {
  final _boards = [for (var i = 0; i < 9; i++) TicTacToeGame()];
  var _lastBoardX = -1;
  var _lastBoardY = -1;
  var _current = _State.X;

  get current => _current;

  _State cellAt(int x, int y) {
    assert(x >= 0 && x < 3);
    assert(y >= 0 && y < 3);
    return _boards[y * 3 + x]._winner;
  }

  Widget _renderBoard(BuildContext context, int boardX, int boardY,
      {Function(TicTacToeGame, int, int) onPressed,
      bool disabled = false,
      size = 40}) {
    // Check if the current (this) board can be played, e.g.
    // if more moves are possible, and no winner.
    final thisBoard = _boards[boardY * 3 + boardX];
    var enabled = !disabled && thisBoard._winner == _State.Empty;
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
      if (nextBoard._winner == _State.Empty) {
        enabled = (nextBoardX == boardX && nextBoardY == boardY);
      }
    }
    return thisBoard.renderBoard(context, onPressed: (gameRow, gameCol) {
      onPressed(thisBoard, gameRow, gameCol);
      _lastBoardX = boardX;
      _lastBoardY = boardY;
      _current = thisBoard.currentPlayer;
    }, disabled: !enabled, size: size);
  }

  Widget renderBoard(BuildContext context,
      {Function(TicTacToeGame, int, int) onPressed}) {
    final winner = checkForWinner();
    final disabled = winner != _State.Empty;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final desiredSize = min(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: desiredSize,
          height: desiredSize,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(disabled ? "" : "It's ${_stateToString[_current]} turn",
                textScaleFactor: desiredSize / 150),
            Expanded(
              child: Stack(alignment: AlignmentDirectional.center, children: [
                Column(mainAxisSize: MainAxisSize.min, children: [
                  for (var row = 0; row < 3; row++)
                    Expanded(
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        for (var col = 0; col < 3; col++)
                          Expanded(
                              child: _renderBoard(context, col, row,
                                  onPressed: onPressed,
                                  disabled: disabled,
                                  size: desiredSize / 9))
                      ]),
                    )
                ]),
                if (disabled)
                  Text(_stateToString[winner],
                      style: const TextStyle(color: Colors.red),
                      textScaleFactor: desiredSize / 20)
              ]),
            )
          ]),
        );
      },
    );
  }
}
