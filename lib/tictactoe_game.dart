import 'dart:math';
import 'package:flutter/material.dart';

import 'keys.dart';

// Great article, and the first one that I remember learning about it
// https://mathwithbaddrawings.com/2013/06/16/ultimate-tic-tac-toe/

// Some game options from the article above:
//  Tie (draw) on the larger board can be considered as both X and O

enum _State { Empty, X, O, Tie }

abstract class _TicTacToeBoard {
  _State cellAt(int x, int y);

  static const _stateToString = {
    _State.Empty: '',
    _State.X: 'X',
    _State.O: 'O',
    _State.Tie: '#',
  };

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
  side: BorderSide.none,
  padding: EdgeInsets.all(0),
  elevation: 0,
  visualDensity: VisualDensity.compact,
  shape: BeveledRectangleBorder(),
);

class TicTacToeCell extends ElevatedButton {
  final int gameX;
  final int gameY;
  final int cellX;
  final int cellY;
  TicTacToeCell(
    this.gameX,
    this.gameY,
    this.cellX,
    this.cellY, {
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    required Widget child,
  }) : super(
            key: Keys.CELLS[gameY * 27 + gameX * 3 + cellY * 9 + cellX],
            onPressed: onPressed,
            onLongPress: onLongPress,
            style: style,
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            child: child);
}

class TicTacToeGame extends _TicTacToeBoard {
  final int gameX;
  final int gameY;
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

  TicTacToeGame(this.gameX, this.gameY) {
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

  Widget _renderCell(int gameX, int gameY, int col, int row,
      {required Function(int, int) onPressed, bool disabled = false, size}) {
    final cell = cellAt(col, row);
    if (cell != _State.Empty) {
      disabled = true;
    } else if (!disabled) {
      disabled = _winner != _State.Empty;
    }
    return Padding(
      padding: EdgeInsets.all(size / 40),
      child: TicTacToeCell(
        gameX,
        gameY,
        col,
        row,
        style: _maximizedElevatedButtonStyle,
        child: Text(_TicTacToeBoard._stateToString[cell]!,
            textAlign: TextAlign.center, textScaleFactor: size / 30),
        onPressed: disabled ? null : () => onPressed(col, row),
      ),
    );
  }

  Widget renderBoard(BuildContext context, int gameX, int gameY,
          {required Function(int, int) onPressed,
          bool disabled = false,
          size}) =>
      Padding(
          padding: EdgeInsets.all(size / 20),
          child: Stack(alignment: AlignmentDirectional.center, children: [
            Column(mainAxisSize: MainAxisSize.min, children: [
              for (var row = 0; row < 3; row++)
                Expanded(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    for (var col = 0; col < 3; col++)
                      Expanded(
                        child: _renderCell(gameX, gameY, col, row,
                            onPressed: onPressed,
                            disabled: disabled,
                            size: size),
                      )
                  ]),
                )
            ]),
            if (_winner != _State.Empty)
              Text(_TicTacToeBoard._stateToString[_winner]!,
                  textScaleFactor: size / 10.0)
          ]));
}

class SuperTicTacToeGame extends _TicTacToeBoard {
  final _boards = [
    for (var y = 0; y < 3; y++)
      for (var x = 0; x < 3; x++) TicTacToeGame(x, y)
  ];
  var _lastBoardX = -1;
  var _lastBoardY = -1;
  var _current = _State.X;

  get current => _current;

  TicTacToeGame _gameAt(int x, int y) {
    assert(x >= 0 && x < 3);
    assert(y >= 0 && y < 3);
    return _boards[y * 3 + x];
  }

  _State cellAt(int x, int y) => _gameAt(x, y)._winner;

  void move(int gameX, int gameY, int cellX, int cellY) {
    final game = _gameAt(gameX, gameY);
    game.move(cellX, cellY, current: _current);
    _lastBoardX = gameX;
    _lastBoardY = gameY;
    _current = game.currentPlayer;
  }

  Widget _renderBoard(BuildContext context, int boardX, int boardY,
      {required Function(int, int, int, int) onPressed,
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
    return thisBoard.renderBoard(context, boardX, boardY,
        onPressed: (gameRow, gameCol) {
      onPressed(boardX, boardY, gameRow, gameCol);
    }, disabled: !enabled, size: size);
  }

  Widget renderBoard(BuildContext context,
      {required Function(int, int, int, int) onPressed,
      Function()? onUndoPressed}) {
    final winner = checkForWinner();
    final disabled = winner != _State.Empty;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final desiredSize = min(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: desiredSize,
          height: desiredSize,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                        disabled
                            ? ""
                            : "It's ${_TicTacToeBoard._stateToString[_current]} turn",
                        textScaleFactor: desiredSize / 150),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(desiredSize / 300),
                  child: ElevatedButton(
                    child: Text('Undo',
                        key: ValueKey("undoButton"),
                        textAlign: TextAlign.center,
                        textScaleFactor: desiredSize / 300),
                    onPressed: onUndoPressed,
                  ),
                ),
              ],
            ),
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
                  Text(_TicTacToeBoard._stateToString[winner]!,
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
