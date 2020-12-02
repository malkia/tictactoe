import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tictactoe/main.dart';
import 'package:tictactoe/main_page.dart';
import 'package:tictactoe/tictactoe_game.dart';

void _printCells(List<TicTacToeCell> cells) {
  var line = "";
  for (var index = 0; index <= cells.length; index++) {
    if (index % 9 == 0) {
      print(line);
      line = "";
      if (index == cells.length) break;
    }
    var cell = cells[index];
    var text = cell.child as Text;
    var data = text.data;
    var enabled = cell.onPressed != null;
    if (index > 0 && index % 27 == 0) {
      print("---+---+---");
    }
    if ((index % 9 != 0) && index % 3 == 0) line = line + "|";
    line = line + (data == '' ? (enabled ? ':' : ' ') : data.toLowerCase());
  }
}

int _pickCell(List<TicTacToeCell> cells) {
  for (var index = 0; index < cells.length; index++) {
    var cell = cells[index];
    var enabled = cell.onPressed != null;
    if (enabled) return index;
  }
  return -1;
}

List<TicTacToeCell> _getCells(WidgetTester tester) {
  var cells = List<TicTacToeCell>(81);
  var allWidgets = tester.widgetList(find.byType(TicTacToeCell)).toList();
  expect(allWidgets.length, cells.length);
  for (TicTacToeCell cell in allWidgets) {
    var index = cell.gameY * 27 + cell.gameX * 3 + cell.cellY * 9 + cell.cellX;
    cells[index] = cell;
  }
  return cells;
}

// List<TicTacToeGame> _getGames(WidgetTester tester) {
//   var games = List<TicTacToeGame>(9);
//   List<TicTacToeGame> allWidgets =
//       tester.widgetList(find.byType(TicTacToeGame)).toList();
//   expect(allWidgets.length, games.length);
//   for (TicTacToeGame game in allWidgets) {
//     var index = game.gameY * 3 + game.gameX;
//     games[index] = game;
//   }
//   return games;
// }

void main() {
  testWidgets('Super Tic Tac Toe', (WidgetTester tester) async {
    await tester.pumpWidget(myApp());
    await expectLater(
        find.byType(MaterialApp), matchesGoldenFile('goldens/super/main.png'));
    await tester.tap(find.byType(SuperTicTacToeStartGameButton));
    await tester.pumpAndSettle();
    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/super/game_start.png'));

    for (;;) {
      var cells = _getCells(tester);
      _printCells(cells);
      var index = _pickCell(cells);
      if (index == -1) break;
      await tester.tap(find.byWidget(cells[index]));
      await tester.pumpAndSettle();
      await expectLater(find.byType(MaterialApp),
          matchesGoldenFile('goldens/super/game_turn_$index.png'));
    }
  });
}
