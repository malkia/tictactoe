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
          child: _state.renderBoard(
              onPressed: (int col, int row) => setState(
                    () => _state.move(col, row),
                  ))));
}

class SuperTicTacToePage extends StatefulWidget {
  @override
  _SuperTicTacToePageState createState() => _SuperTicTacToePageState();
}

class _SuperTicTacToePageState extends State<SuperTicTacToePage> {
  final _state = SuperTicTacToeGame();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Super Tic Tac Toe")),
      body: Center(
          child: _state.renderBoard(
              onPressed: (TicTacToeGame game, int col, int row) => setState(
                    () => game.move(col, row, current: _state.current),
                  ))));
}
