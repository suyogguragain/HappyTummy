import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/sections/components/constants.dart';
import 'package:happy_tummy/restaurant/sections/components/section_title.dart';

class FeedbackSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding ,horizontal:kDefaultPadding ),
      // constraints: BoxConstraints(maxWidth: 1110),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFE8F0F9),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/bg_img_2.png"),
        ),
      ),
      child: Column(
        children: [
          SectionTitle(
            title: "Reviews Received",
            subTitle: "Client’s reviews",
            color: Color(0xFF00B1FF),
          ),
          SizedBox(height: kDefaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Reviews"),
              Text("Reviews"),
              Text("Reviews"),
            ]
          ),
        ],
      ),
    );
  }
}