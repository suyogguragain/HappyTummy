import 'package:flutter/material.dart';

import 'homescreen.dart';



class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Happy Tummy App",
        theme: ThemeData( primaryColor: Colors.blueAccent ),
        home: HomeScreen(),
      );
  }
}
