import 'package:flutter/material.dart';

class HomeTopInfo extends StatelessWidget {
  final textStyle = TextStyle(fontSize: 30.0, fontWeight: FontWeight.normal,);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Guide you the',style: textStyle,),
              Text('best place to eat !',style: textStyle),
            ],
          ),
          Icon(Icons.notifications_none, size: 32.0, color: Colors.pinkAccent,),
        ],
      ),
    );
  }
}
