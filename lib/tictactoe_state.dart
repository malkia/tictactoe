enum Cell { Empty, X, O }

const cellText = {
  Cell.Empty: ' ',
  Cell.X: 'X',
  Cell.O: 'O',
};

const cellChecks = [
  [0, 0, 0, 1],
  [1, 0, 0, 1],
  [2, 0, 0, 1],
  [0, 0, 1, 0],
  [0, 1, 1, 0],
  [0, 2, 1, 0],
  [0, 0, 1, 1],
  [0, 2, 1, -1],
];

class TicTacToeState {
  var _cells = List<Cell>(9);
  var _current = Cell.X;
  var _winner = Cell.Empty;
  var _moreMoves = true;

  get winner => _winner;
  get moreMoves => _moreMoves;

  TicTacToeState() {
    reset();
  }

  void reset() {
    _cells.fillRange(0, _cells.length, Cell.Empty);
    _current = Cell.X;
    _winner = _checkForWinner();
    _moreMoves = _checkForMoreMoves();
  }

  String textAt(int x, int y) {
    var cell = _cells[y * 3 + x];
    return cellText[cell];
  }

  bool move(int x, int y) {
    if (_cells[y * 3 + x] != Cell.Empty) {
      return false;
    }
    _cells[y * 3 + x] = _current;
    _current = _current == Cell.O ? Cell.X : Cell.O;
    _winner = _checkForWinner();
    _moreMoves = _checkForMoreMoves();
    return true;
  }

  Cell _checkThreeNeighbours(int x, int y, int dx, int dy) {
    var prevCell = Cell.Empty;
    for (int i = 0; i < 3; i++) {
      var index = (y + dy * i) * 3 + x + dx * i;
      assert(index >= 0 && index < 9);
      var cell = _cells[index];
      if (i > 0 && (cell == Cell.Empty || prevCell != cell)) return Cell.Empty;
      prevCell = cell;
    }
    return prevCell;
  }

  bool _checkForMoreMoves() {
    return _cells.contains(Cell.Empty);
  }

  Cell _checkForWinner() {
    for (var c in cellChecks) {
      var cell = _checkThreeNeighbours(c[0], c[1], c[2], c[3]);
      if (cell != Cell.Empty) return cell;
    }
    return Cell.Empty;
  }
}
