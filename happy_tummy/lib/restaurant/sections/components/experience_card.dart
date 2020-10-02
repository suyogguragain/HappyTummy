import 'package:flutter/material.dart';
import 'file:///D:/ProgramFiles/Flutter_projects/HappyTummy/happy_tummy/lib/restaurant/sections/components/constants.dart';


class ExperienceCard extends StatelessWidget {
  const ExperienceCard({
    Key key,
    this.numOfExp,
  }) : super(key: key);

  final String numOfExp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: Color(0xFFF7E8FF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0xFFEDD2FC),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 6,
              color: Color(0xFFA600FF).withOpacity(0.25),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Text(
                  numOfExp,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black54,
                  ),
                )
              ],
            ),
            SizedBox(height: kDefaultPadding / 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                "Years of Experience",
                style: TextStyle(
                  color: Color(0xFFA600FF),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}