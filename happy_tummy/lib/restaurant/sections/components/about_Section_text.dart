import 'package:flutter/material.dart';
import 'file:///D:/ProgramFiles/Flutter_projects/HappyTummy/happy_tummy/lib/restaurant/sections/components/constants.dart';


class AboutSectionText extends StatelessWidget {
  const AboutSectionText({
    Key key,
    this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Text(
        text,
        style: TextStyle(
            fontWeight: FontWeight.w400, color: Colors.black,fontSize: 14,height: 1.5),
      ),
    );
  }
}