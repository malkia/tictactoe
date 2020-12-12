import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:integration_test/integration_test.dart';

import '../lib/keys.dart';
import '../lib/main.dart';
import '../lib/tictactoe_game.dart';

void _printCells() {
  var line = "";
  for (var index = 0; index <= Keys.CELLS.length; index++) {
    if (index % 9 == 0) {
      print(line);
      line = "";
      if (index == Keys.CELLS.length) break;
    }
    var key = Keys.CELLS[index];
    var cell = find.byKey(key).evaluate().single.widget as TicTacToeCell;
    var data = (cell.child as Text).data;
    var enabled = cell.onPressed != null;
    if (index > 0 && index % 27 == 0) {
      print("---+---+---");
    }
    if ((index % 9 != 0) && index % 3 == 0) line = line + "|";
    line = line + (data == '' ? (enabled ? ':' : ' ') : data!.toLowerCase());
  }
}

ValueKey? _pickCell() {
  for (var key in Keys.CELLS) {
    var cell = find.byKey(key).evaluate().single.widget as TicTacToeCell;
    if (cell.onPressed != null) return key;
  }
  return null;
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Super Tic Tac Toe', (WidgetTester tester) async {
    await tester.pumpWidget(myApp());
    await tester.tap(find.byKey(Keys.START_BUTTON));
    await tester.pumpAndSettle();

    for (var turn = 0; turn < 99; turn++) {
      _printCells();
      var key = _pickCell();
      if (key == null) break;
      await tester.tap(find.byKey(key));
      await tester.pumpAndSettle();
      await expectLater(find.byType(MaterialApp),
          matchesGoldenFile('goldens/super/game_turn_$turn.png'));
    }
  });
}
