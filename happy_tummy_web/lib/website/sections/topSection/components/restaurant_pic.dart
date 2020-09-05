import 'package:flutter/material.dart';

class RestaurantPic extends StatelessWidget {
  const RestaurantPic({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 639, maxHeight: 860),
      child: CircleAvatar(
          radius: 240,
          backgroundImage: AssetImage("assets/images/trisara.jpeg"),
        ),//Image.asset("assets/images/trisara.jpeg"),
    );
  }
}