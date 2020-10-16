import 'package:flutter/material.dart';

import '../constants.dart';


class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Container(
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 95,
              backgroundColor: Color(0xffFDCF09),
              child: CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage('assets/images/ht.png'),
              ),
            ),
            SizedBox(height: 15,),
            Center(
              child: Text(
                "Happy Tummy",
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 36,
                  fontFamily: "Lobster"
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}