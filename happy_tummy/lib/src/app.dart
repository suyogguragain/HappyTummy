import 'package:flutter/material.dart';
import 'package:happy_tummy/src/scoped-model/main_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'pages/signin_page.dart';
import 'screens/main_screen.dart';



class App extends StatelessWidget {

  final MainModel mainModel = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Happy Tummy App",
        theme: ThemeData(primaryColor: Colors.blueAccent),
        routes: {
          "/": (BuildContext context) => SignInPage(),
          "/mainscreen": (BuildContext context) => MainScreen(
            model: mainModel,
          ),
        },
      ),
    );
  }
}
