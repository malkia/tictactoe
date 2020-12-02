import 'dart:io';

import 'package:flutter/material.dart';

import 'tictactoe_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Tic Tac Toes")),
      body: Center(
        child: Column(
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
            ElevatedButton(
              child: Text('Exit', textScaleFactor: 3.0),
              onPressed: () => exit(0),
            ),
          ],
        ),
      ));
}

class SuperTicTacToeStartGameButton extends StatelessWidget {
  const SuperTicTacToeStartGameButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Super\nTic Tac Toe',
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
