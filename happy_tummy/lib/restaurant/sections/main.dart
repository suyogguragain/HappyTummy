import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/models/restaurants.dart';
import 'package:happy_tummy/restaurant/sections/components/about_Section_text.dart';
import 'package:happy_tummy/restaurant/sections/components/about_text_with_sign.dart';
import 'package:happy_tummy/restaurant/sections/components/experience_card.dart';
import 'package:happy_tummy/restaurant/sections/components/feedback.dart';
import 'package:happy_tummy/restaurant/sections/components/qrcode/qrcode.dart';
import 'file:///D:/ProgramFiles/Flutter_projects/HappyTummy/happy_tummy/lib/restaurant/sections/components/constants.dart';
import 'package:happy_tummy/restaurant/ui/pages/splash.dart';

final restaurantsReference = Firestore.instance.collection('restaurants');

class MainPage extends StatefulWidget {
  final String restaurantProfileId;

  MainPage({this.restaurantProfileId});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder(
                future: restaurantsReference
                    .document(widget.restaurantProfileId)
                    .get(),
                builder: (context, dataSnapshot) {
                  if (!dataSnapshot.hasData) {
                    return Splash();
                  }
                  Restaurant restaurant =
                      Restaurant.fromDocument(dataSnapshot.data);
                  return Column(children: [
                    //Top Section
                    Container(
                      alignment: Alignment.center,
                      constraints:
                          BoxConstraints(maxHeight: 250, minHeight: 100),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/back1.jpg"),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: kDefaultPadding),
                        width: 300,
                        child: Stack(
                          children: [
                            //Blur BOx
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Spacer(),
                                //Glass Content
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: kDefaultPadding * 2),
                                      constraints: BoxConstraints(
                                          maxWidth: 300, maxHeight: 200),
                                      width: double.infinity,
                                      color: Colors.white.withOpacity(0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Hello There!",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            "${restaurant.name} \n${restaurant.location}",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              height: 1.5,
                                            ),
                                          ),
                                          Text(
                                            '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 40,
                              right: -10,
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 300, maxHeight: 200),
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: CachedNetworkImageProvider(
                                      restaurant.photo),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    //About SEction
                    Container(
                      constraints: BoxConstraints(maxWidth: 400),
                      child: Column(
                        children: [
                          AboutTextWithSign(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: AboutSectionText(
                                    text:
                                        'Cusines : ${restaurant.cusines}\nMeal type : ${restaurant.mealtype}\nOutlet Type : ${restaurant.outlettype}'),
                              ),
                              Expanded(
                                child: AboutSectionText(
                                    text:
                                        "Additional Info\nParking : ${restaurant.parking}\nPayment Method : ${restaurant.paymentmethod}\nBillingExtra : ${restaurant.billingextra}"),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, left: 20,right: 50),
                                child: Container(
                                  child: ExperienceCard(
                                      numOfExp:
                                          "${(DateTime.now().year - restaurant.age.toDate().year).toString()}"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: FlatButton.icon(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  color: Color(0xFFE8F0F9),
                                  icon: Icon(Icons.edit),
                                  label: Text('Edit Profile'), //`Text` to display
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: kDefaultPadding),
                        ],
                      ),
                    ),
                  ]);
                }),
            FeedbackSection(),
            SizedBox(height: kDefaultPadding),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QRCode(),
            ),
          );
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
