import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tictactoe_page_getx.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text("Tic Tac Toes"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Spacer(flex: 5),
            ElevatedButton(
              child: Text(
                'Tic Tac Toe',
                textScaleFactor: 4.0,
              ),
              onPressed: () => Get.to(TicTacToePageGetX()),
            ),
            Spacer(flex: 2),
            ElevatedButton(
              child: Text(
                'Super Tic Tac Toe',
                textScaleFactor: 4.0,
              ),
              onPressed: () => Get.to(SuperTicTacToePageGetX()),
            ),
            Spacer(flex: 6),
            ElevatedButton(
              child: Text(
                'Exit',
                textScaleFactor: 4.0,
              ),
              onPressed: () => exit(0),
            ),
            Spacer(flex: 3),
          ],
        ),
      ));
}
