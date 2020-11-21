import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tictactoe_page_getx.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Tic Tac Toes")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: Text('Tic Tac Toe', textScaleFactor: 3.0),
              onPressed: () => Get.to(TicTacToePage()),
            ),
            ElevatedButton(
              child: Text('Super\nTic Tac Toe',
                  textScaleFactor: 3.0, textAlign: TextAlign.center),
              onPressed: () => Get.to(SuperTicTacToePage()),
            ),
            ElevatedButton(
              child: Text('Exit', textScaleFactor: 3.0),
              onPressed: () => exit(0),
            ),
          ],
        ),
      ));
}
