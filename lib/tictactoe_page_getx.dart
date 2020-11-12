import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tictactoe_state.dart';

class TicTacToeGame {
  final _state = TicTacToeState().obs;

  Widget renderCell(int row, int col) => ElevatedButton(
        child: Text(
          _state.value.textAt(col, row),
          textScaleFactor: 4.0,
        ),
        onPressed: () {
          if (!_state.value.move(col, row)) {
            Get.snackbar("Invalid move", "Cell taken",
                snackPosition: SnackPosition.BOTTOM);
          } else {
            _state.refresh();
          }
        },
      );

  Widget renderRow(int row) => Row(children: [
        Spacer(flex: 9),
        renderCell(row, 0),
        Spacer(flex: 1),
        renderCell(row, 1),
        Spacer(flex: 1),
        renderCell(row, 2),
        Spacer(flex: 9),
      ]);

  Widget render() => Obx(() {
        final s = _state.value;
        if (s.winner != Cell.Empty)
          return Text("The winner is ${cellText[_state.value.winner]}",
              textScaleFactor: 4.0);

        // No one has won, but no more moves can be made, so it's a draw.
        if (!s.moreMoves) return Text("It's a DRAW!", textScaleFactor: 4.0);

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

class TicTacToePageGetX extends StatelessWidget {
  final _game = TicTacToeGame();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Tic Tac Toe")),
        body: Center(child: _game.render()),
      );
}
