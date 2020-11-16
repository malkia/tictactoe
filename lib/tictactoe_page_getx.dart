import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tictactoe_game.dart';

class TicTacToePageGetX extends StatelessWidget {
  final _state = TicTacToeGame().obs;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toe"),
      ),
      body: Center(
        child: Obx(() => _state.value.renderBoard(
              onPressed: (int col, int row) {
                _state.value.move(col, row);
                _state.refresh();
              },
            )),
      ));
}

class SuperTicTacToePageGetX extends StatelessWidget {
  final _state = SuperTicTacToeGame().obs;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Super Tic Tac Toe"),
      ),
      body: Center(
        child: Obx(() => _state.value.renderBoard(
              onPressed: (TicTacToeGame game, int col, int row) {
                game.move(col, row, current: _state.value.current);
                _state.refresh();
              },
            )),
      ));
}
