import 'package:flutter/material.dart';

class AboutTextWithSign extends StatelessWidget {
  const AboutTextWithSign({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "General Info",
          style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.normal,fontSize: 30,fontFamily: 'EastSeaDokdo'),
        ),
      ],
    );
  }
}
