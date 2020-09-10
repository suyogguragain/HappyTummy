
import 'package:flutter/material.dart';
import 'package:happy_tummy_web/authentication/auth_service.dart';
import 'package:happy_tummy_web/website/constants.dart';

class WebApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Happy Tummy',
      theme: ThemeData(
        inputDecorationTheme: kDefaultInputDecorationTheme,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: WebHomePage(),
      //home: SignUp(),
      home: AuthService().handleAuth()
    );
  }
}
