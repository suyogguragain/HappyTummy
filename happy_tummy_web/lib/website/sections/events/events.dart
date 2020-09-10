import 'package:flutter/material.dart';
import 'package:happy_tummy_web/website/components/hire_me_card.dart';
import 'package:happy_tummy_web/website/components/section_title.dart';
import 'package:happy_tummy_web/website/constants.dart';
import 'package:happy_tummy_web/website/models/events_list.dart';
import 'package:happy_tummy_web/website/sections/events/components/events_card.dart';

class EventsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: kDefaultPadding * 6),
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
              Transform.translate(
                offset: Offset(0, -80),
                child: HireMeCard(),
              ),
              SectionTitle(
                title: "Recent Woorks",
                subTitle: "My Strong Arenas",
                color: Color(0xFFFFB100),
              ),
              SizedBox(height: kDefaultPadding * 1.5),
              SizedBox(
                width: 1110,
                child: Wrap(
                  spacing: kDefaultPadding,
                  runSpacing: kDefaultPadding * 2,
                  children: List.generate(
                    recentWorks.length,
                    (index) => EventsCard(index: index, press: () {}),
                  ),
                ),
              ),
              SizedBox(height: kDefaultPadding * 5),
            ],
          ),
        ),
      ),
    );
  }
}
