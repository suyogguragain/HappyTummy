import 'package:flutter/material.dart';
import 'package:happy_tummy_web/website/constants.dart';
import 'package:happy_tummy_web/website/sections/about/components/about_Section_text.dart';
import 'package:happy_tummy_web/website/sections/about/components/about_text_with_sign.dart';
import 'package:happy_tummy_web/website/sections/about/components/experience_card.dart';

class AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding * 2),
      constraints: BoxConstraints(maxWidth: 1110),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AboutTextWithSign(),
              Expanded(
                child: AboutSectionText(
                    text:
                        'Cusines : Fastfood\nMeal type : Lunch\nAmenities : Free wifi, Paid Parking'),
              ),
              ExperienceCard(numOfExp: "08"),
              Expanded(
                child: AboutSectionText(
                    text:
                        "Additional Info\nOutlet Type : Casual\nParking : 2wheeler Parking, 4wheeler Parking\nPayment Method : Card and Cash\nBillingExtra : Service charge, VAT"),
              ),
            ],
          ),
          SizedBox(height: kDefaultPadding * 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton.icon(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                color: Color(0xFFE8F0F9),
                icon: Icon(Icons.edit), 
                label: Text('Edit Profile'), //`Text` to display
                onPressed: () {
                  
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
