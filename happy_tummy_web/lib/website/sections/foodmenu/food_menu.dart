import 'package:flutter/material.dart';
import 'package:happy_tummy_web/website/components/section_title.dart';
import 'package:happy_tummy_web/website/constants.dart';

class FoodmenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF7E8FF).withOpacity(0.3),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/recent_work_bg.png"),
            ),
          ),
          child: Column(
            children: [
              SectionTitle(
                title: "Recent Woorks",
                subTitle: "My Strong Arenas",
                color: Color(0xFFFFB100),
              ),
              SizedBox(height: kDefaultPadding * 1.5),
            ],
          ),
        ),
      ),
    );
  }
}
