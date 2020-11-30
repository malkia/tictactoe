import 'package:flutter/material.dart';
import 'tictactoe_game.dart';

class TicTacToePage extends StatefulWidget {
  @override
  _TicTacToePageState createState() => _TicTacToePageState();
}

class _TicTacToePageState extends State<TicTacToePage> {
  final _state = TicTacToeGame();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Tic Tac Toe")),
      body: Center(
          child: _state.renderBoard(context,
              onPressed: (int col, int row) => setState(
                    () => _state.move(col, row),
                  ))));
}

class SuperTicTacToePage extends StatefulWidget {
  @override
  _SuperTicTacToePageState createState() => _SuperTicTacToePageState();
}

class _SuperTicTacToeRecord {
  int gameX, gameY;
  int cellX, cellY;
  _SuperTicTacToeRecord(this.gameX, this.gameY, this.cellX, this.cellY);
}

class _SuperTicTacToePageState extends State<SuperTicTacToePage> {
  var _state = SuperTicTacToeGame();
  final _record = List<_SuperTicTacToeRecord>();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Super Tic Tac Toe")),
      body: Center(
        child: _state.renderBoard(context,
            onPressed: (int gameX, int gameY, int cellX, int cellY) => setState(
                  () {
                    var r = _SuperTicTacToeRecord(gameX, gameY, cellX, cellY);
                    _record.add(r);
                    _state.move(gameX, gameY, cellX, cellY);
                  },
                ),
            onUndoPressed: _record.isEmpty
                ? null
                : () {
                    _record.removeAt(_record.length - 1);
                    setState(() {
                      _state = SuperTicTacToeGame();
                    });
                    for (var r in _record) {
                      setState(() =>
                          _state.move(r.gameX, r.gameY, r.cellX, r.cellY));
                    }
                  }),
      ));
}
