import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'tictactoe_page_getx.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tic Tac Toes"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Spacer(flex: 5),
              RaisedButton(
                child: Text('New Game', textScaleFactor: 4.0,),
                onPressed: () => Get.to(TicTacToePageGetX()),
              ),
              Spacer(flex: 6),
              RaisedButton(
                child: Text('Exit', textScaleFactor: 4.0,),
                onPressed: () => exit(0),
              ),
              Spacer(flex: 3),
            ],
          ),
        ));
  }
}
