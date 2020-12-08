import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'tictactoe_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("TIC TAC TOES")),
      body: Center(
        child: Column(
          key: ValueKey("startButton"),
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ElevatedButton(
            //   child: Text('Tic Tac Toe', textScaleFactor: 3.0),
            //   onPressed: () => {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => TicTacToePage()),
            //     )
            //   },
            // ),
            SuperTicTacToeStartGameButton(),
            if (!kIsWeb)
              ElevatedButton(
                child: Text('EXIT', textScaleFactor: 3.0),
                onPressed: () => exit(0),
              ),
          ],
        ),
      ));
}

class SuperTicTacToeStartGameButton extends StatelessWidget {
  static final uniqueKey = ValueKey("undoButton");
  SuperTicTacToeStartGameButton() : super(key: uniqueKey);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('S U P E R\nTIC TAC TOE',
          textScaleFactor: 3.0, textAlign: TextAlign.center),
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SuperTicTacToePage()),
        )
      },
    );
  }
}
