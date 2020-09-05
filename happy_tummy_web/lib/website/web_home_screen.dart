import 'package:flutter/material.dart';
import 'package:happy_tummy_web/website/constants.dart';
import 'package:happy_tummy_web/website/sections/about/about_section.dart';
import 'package:happy_tummy_web/website/sections/feedback/feedback_section.dart';
import 'package:happy_tummy_web/website/sections/topSection/top_section.dart';

class WebHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TopSection(),
            SizedBox(height: kDefaultPadding * 2),
            AboutSection(),
            FeedbackSection(),
            SizedBox(height: kDefaultPadding),
          ],
        ),
      ),
    );
  }
}
