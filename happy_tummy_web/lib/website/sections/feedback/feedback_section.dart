import 'package:flutter/material.dart';
import 'package:happy_tummy_web/website/components/section_title.dart';
import 'package:happy_tummy_web/website/constants.dart';
import 'package:happy_tummy_web/website/models/Feedback.dart';
import 'package:happy_tummy_web/website/sections/feedback/components/feedback_card.dart';

class FeedbackSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: kDefaultPadding * 2.5),
      constraints: BoxConstraints(maxWidth: 1110),
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
            children: List.generate(
              feedbacks.length,
              (index) => FeedbackCard(index: index),
            ),
          ),
        ],
      ),
    );
  }
}