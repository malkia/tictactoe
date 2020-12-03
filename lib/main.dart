import 'package:flutter/material.dart';
import 'main_page.dart';

void main() {
  runApp(myApp());
}

MaterialApp myApp() => MaterialApp(
      home: MainPage(),
      theme: ThemeData(fontFamily: "Nova Mono"),
    );
