
import 'package:flutter/material.dart';
import 'package:happy_tummy_web/website/constants.dart';
import 'package:happy_tummy_web/website/web_home_screen.dart';

class WebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: kDefaultInputDecorationTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WebHomePage(),
    );
  }
}
