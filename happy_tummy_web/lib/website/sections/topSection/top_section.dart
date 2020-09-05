import 'package:flutter/material.dart';
import 'package:happy_tummy_web/website/constants.dart';
import 'package:happy_tummy_web/website/sections/topSection/components/logo_blur_box.dart';
import 'package:happy_tummy_web/website/sections/topSection/components/menu.dart';
import 'package:happy_tummy_web/website/sections/topSection/components/restaurant_pic.dart';

class TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(maxHeight: 800, minHeight: 600),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/back1.jpg"),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: kDefaultPadding),
        width: 1100,
        child: Stack(
          children: [
            LogoAndBlurBox(size: size),
            Positioned(
              bottom: 0,
              right: 0,
              child: RestaurantPic(),
            ),
            Positioned(
              bottom: 0,
              child: Menu(),
            ),
          ],
        ),
      ),
    );
  }
}
