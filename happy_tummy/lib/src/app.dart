import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HappyTummy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.black,
      ),
      home: TopLevelPage(),
    );
  }
}
