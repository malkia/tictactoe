import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tictactoe_state.dart';

class TicTacToeGame {
  var _state = TicTacToeState().obs;

  TicTacToeGame() {
    reset();
  }

  void reset() {
    _state.value.reset();
    _state.refresh();
  }

  Widget renderCell(int row, int col) {
    var s = _state.value;
    return RaisedButton(
      child: Text(
        s.textAt(col, row),
        textScaleFactor: 4.0,
      ),
      onPressed: () {
        if (!s.move(col, row)) {
          Get.snackbar("Invalid move", "Cell taken",
              snackPosition: SnackPosition.BOTTOM);
        } else {
          _state.refresh();
        }
      },
    );
  }

  Widget renderRow(int row) => Row(children: [
        Spacer(flex: 9),
        renderCell(row, 0),
        Spacer(flex: 1),
        renderCell(row, 1),
        Spacer(flex: 1),
        renderCell(row, 2),
        Spacer(flex: 9),
      ]);

  Widget render() {
    return Obx(() {
      var s = _state.value;
      if (s.winner != Cell.Empty) {
        return Text("The winner is ${cellText[_state.value.winner]}",
            textScaleFactor: 4.0);
      }

      // No one has won, but no more moves can be made, so it's a draw.
      if (!s.moreMoves) {
        return Text("It's a DRAW!", textScaleFactor: 4.0);
      }

      return Column(
        children: [
          Spacer(flex: 9),
          renderRow(0),
          Spacer(flex: 1),
          renderRow(1),
          Spacer(flex: 1),
          renderRow(2),
          Spacer(flex: 9),
        ],
      );
    });
  }
}

class TicTacToePageGetX extends StatelessWidget {
  final _game = TicTacToeGame();

  TicTacToePageGetX({Key key}) : super(key: key) {
    _game.reset();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Tic Tac Toe")),
        body: Center(child: _game.render()),
      );
}
