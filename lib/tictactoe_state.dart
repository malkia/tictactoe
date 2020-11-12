enum Cell { Empty, X, O }

const _cellText = {
  Cell.Empty: ' ',
  Cell.X: 'X',
  Cell.O: 'O',
};

get cellText => _cellText;

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
    _cells.fillRange(0, _cells.length, Cell.Empty);
    _current = Cell.X;
    _winner = _checkForWinner();
    _moreMoves = _checkForMoreMoves();
  }

  Cell cellAt(int x, int y) {
    var index = y * 3 + x;
    assert(index >= 0 && index < _cells.length);
    return _cells[index];
  }

  String textAt(int x, int y) => _cellText[cellAt(x, y)];

  bool move(int x, int y) {
    final index = y * 3 + x;
    assert(index >= 0 && index < _cells.length);
    if (_cells[index] != Cell.Empty) {
      return false;
    }
    _cells[index] = _current;
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

  bool _checkForMoreMoves() => _cells.contains(Cell.Empty);

  Cell _checkForWinner() {
    for (var c in cellChecks) {
      var cell = _checkThreeNeighbours(c[0], c[1], c[2], c[3]);
      if (cell != Cell.Empty) return cell;
    }
    return Cell.Empty;
  }
}
