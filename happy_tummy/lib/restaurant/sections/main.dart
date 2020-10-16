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
import 'package:happy_tummy/restaurant/sections/components/restaurant_notification.dart';
import 'file:///D:/ProgramFiles/Flutter_projects/HappyTummy/happy_tummy/lib/restaurant/sections/components/constants.dart';
import 'package:happy_tummy/restaurant/ui/pages/splash.dart';
import 'package:happy_tummy/src/pages/restaurant_reviewview.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

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
      body: Stack(
        children: [
          FutureBuilder(
            future:
                restaurantsReference.document(widget.restaurantProfileId).get(),
            builder: (context, dataSnapshot) {
              if (!dataSnapshot.hasData) {
                return Splash();
              }
              Restaurant restaurant =
                  Restaurant.fromDocument(dataSnapshot.data);
              return Stack(
                children: [
                  SizedBox.expand(
                    child: Image.network(
                      restaurant.photo,
                      fit: BoxFit.cover,
                    ),
                  ),
                  DraggableScrollableSheet(
                    minChildSize: 0.1,
                    initialChildSize: 0.22,
                    builder: (context, scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height),
                          color: Colors.white,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //for user profile header
                              Container(
                                padding: EdgeInsets.only(
                                    left: 32, right: 32, top: 32),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipOval(
                                          child: Image.network(
                                            restaurant.photo,
                                            fit: BoxFit.cover,
                                          ),
                                        )),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            restaurant.name,
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontFamily: "Roboto",
                                                fontSize: 36,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.call,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                              Text(
                                                restaurant.phone,
                                                style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontFamily: "Roboto",
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //performance bar
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: EdgeInsets.all(32),
                                color: Colors.black87,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.restaurant,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              '${(DateTime.now().year - restaurant.age.toDate().year).toString()}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Roboto",
                                                  fontSize: 24),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "Years Old",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Roboto",
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap:(){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=> RestaurantNotificationPage(restaurantid: widget.restaurantProfileId,)));
                                      },
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.notifications_none,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Notifications",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
                                                fontFamily: "Roboto",
                                                fontSize: 15),
                                          )
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.star,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text(
                                              "5",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Roboto",
                                                  fontSize: 24),
                                            )
                                          ],
                                        ),
                                        Text(
                                          "Ratings",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: "Roboto",
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 16,
                              ),
                              //container for about me
                              Container(
                                padding: EdgeInsets.only(left: 32, right: 32),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "About Me",
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto",
                                          fontSize: 25),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${restaurant.name} is located at ${restaurant.location} . We are specially known for ${restaurant.mealtype} (mealtype) and ${restaurant.cusines} (cusines) as we have ${restaurant.outlettype} outlets. \n"
                                      "\nAdditional Information::\nBilling extra : ${restaurant.billingextra}\nParking : ${restaurant.parking}\nPayment Method : ${restaurant.paymentmethod}",
                                      style: TextStyle(
                                          fontFamily: "Roboto", fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              //Container for opening hours
                              Container(
                                padding: EdgeInsets.only(left: 32, right: 32),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        "Opening Hours",
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Roboto",
                                            fontSize: 25),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Sunday : ${restaurant.sun}\nMonday : ${restaurant.mon}\nTuesday : ${restaurant.tue}\nThrusday : ${restaurant.thru}\nFriday : ${restaurant.fri}\nSaturday : ${restaurant.sat}\n",
                                        style: TextStyle(
                                            fontFamily: "Roboto", fontSize: 15),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 32, right: 32),
                                child: Column(
                                  children: <Widget>[
                                    Center(
                                      child: Text(
                                        "Reviews",
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Roboto",
                                            fontSize: 25),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //Container for reviews
                              Container(
                                height: 300,
                                child: StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('restaurantreviews')
                                      .document(widget.restaurantProfileId)
                                      .collection('reviews')
                                      .orderBy("timestamp", descending: false)
                                      .snapshots(),
                                  builder: (context, dataSnapshot) {
                                    if (!dataSnapshot.hasData) {
                                      return Text("No reviews");
                                    }
                                    List<Review> reviews = [];
                                    dataSnapshot.data.documents
                                        .forEach((document) {
                                      reviews
                                          .add(Review.fromDocument(document));
                                    });
                                    return ListView(
                                      children: reviews,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          )
        ],
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
//    return Scaffold(
//      body: SingleChildScrollView(
//        child: Column(
//          children: [
//            FutureBuilder(
//                future: restaurantsReference
//                    .document(widget.restaurantProfileId)
//                    .get(),
//                builder: (context, dataSnapshot) {
//                  if (!dataSnapshot.hasData) {
//                    return Splash();
//                  }
//                  Restaurant restaurant =
//                      Restaurant.fromDocument(dataSnapshot.data);
//                  return Column(children: [
//                    //Top Section
//                    Container(
//                      alignment: Alignment.center,
//                      constraints:
//                          BoxConstraints(maxHeight: 250, minHeight: 100),
//                      width: double.infinity,
//                      decoration: BoxDecoration(
//                        image: DecorationImage(
//                          fit: BoxFit.cover,
//                          image: AssetImage("assets/images/back1.jpg"),
//                        ),
//                      ),
//                      child: Container(
//                        margin: EdgeInsets.only(top: kDefaultPadding),
//                        width: 300,
//                        child: Stack(
//                          children: [
//                            //Blur BOx
//                            Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: [
//                                Spacer(),
//                                //Glass Content
//                                ClipRRect(
//                                  borderRadius: BorderRadius.circular(10),
//                                  child: BackdropFilter(
//                                    filter: ImageFilter.blur(
//                                        sigmaX: 10, sigmaY: 10),
//                                    child: Container(
//                                      padding: EdgeInsets.symmetric(
//                                          horizontal: kDefaultPadding * 2),
//                                      constraints: BoxConstraints(
//                                          maxWidth: 300, maxHeight: 200),
//                                      width: double.infinity,
//                                      color: Colors.white.withOpacity(0),
//                                      child: Column(
//                                        crossAxisAlignment:
//                                            CrossAxisAlignment.start,
//                                        mainAxisAlignment:
//                                            MainAxisAlignment.center,
//                                        children: [
//                                          Text(
//                                            "Hello There!",
//                                            style: TextStyle(
//                                              fontSize: 20,
//                                              color: Colors.white,
//                                            ),
//                                          ),
//                                          Text(
//                                            "${restaurant.name} \n${restaurant.location}",
//                                            style: TextStyle(
//                                              fontSize: 18,
//                                              fontWeight: FontWeight.bold,
//                                              color: Colors.white,
//                                              height: 1.5,
//                                            ),
//                                          ),
//                                          Text(
//                                            '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
//                                            style: TextStyle(
//                                              fontSize: 15,
//                                              fontWeight: FontWeight.bold,
//                                              color: Colors.white,
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            ),
//                            Positioned(
//                              bottom: 40,
//                              right: -10,
//                              child: Container(
//                                constraints: BoxConstraints(
//                                    maxWidth: 300, maxHeight: 200),
//                                child: CircleAvatar(
//                                  radius: 70,
//                                  backgroundImage: CachedNetworkImageProvider(
//                                      restaurant.photo),
//                                ),
//                              ),
//                            ),
//                          ],
//                        ),
//                      ),
//                    ),
//                    SizedBox(height: 20),
//                    //About SEction
//                    Container(
//                      constraints: BoxConstraints(maxWidth: 400),
//                      child: Column(
//                        children: [
//                          AboutTextWithSign(),
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                            children: [
//                              Expanded(
//                                child: AboutSectionText(
//                                    text:
//                                        'Cusines : ${restaurant.cusines}\nMeal type : ${restaurant.mealtype}\nOutlet Type : ${restaurant.outlettype}'),
//                              ),
//                              Expanded(
//                                child: AboutSectionText(
//                                    text:
//                                        "Additional Info\nParking : ${restaurant.parking}\nPayment Method : ${restaurant.paymentmethod}\nBillingExtra : ${restaurant.billingextra}"),
//                              ),
//                            ],
//                          ),
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: [
//                              Padding(
//                                padding:
//                                    const EdgeInsets.only(top: 12, left: 20,right: 50),
//                                child: Container(
//                                  child: ExperienceCard(
//                                      numOfExp:
//                                          "${(DateTime.now().year - restaurant.age.toDate().year).toString()}"),
//                                ),
//                              ),
//                              Padding(
//                                padding: const EdgeInsets.only(top: 40),
//                                child: FlatButton.icon(
//                                  shape: RoundedRectangleBorder(
//                                      borderRadius: BorderRadius.circular(50)),
//                                  color: Color(0xFFE8F0F9),
//                                  icon: Icon(Icons.edit),
//                                  label: Text('Edit Profile'), //`Text` to display
//                                  onPressed: () {},
//                                ),
//                              ),
//                            ],
//                          ),
//                          SizedBox(height: kDefaultPadding),
//                        ],
//                      ),
//                    ),
//                  ]);
//                }),
//            FeedbackSection(),
//            SizedBox(height: kDefaultPadding),
//          ],
//        ),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => QRCode(),
//            ),
//          );
//        },
//        child: Icon(Icons.qr_code_scanner),
//      ),
//    );
  }
}
