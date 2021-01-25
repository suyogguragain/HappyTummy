import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/order/screen/fooddetail_page.dart';

class FoodItemModel extends StatelessWidget {
  String name;
  String description;
  Timestamp publishedDate;
  String url;
  String category;
  int price;
  String fooditemId;
  String restaurantid;

  FoodItemModel({
    this.name,
    this.description,
    this.publishedDate,
    this.url,
    this.category,
    this.price,
    this.fooditemId,
    this.restaurantid,
  });

  factory FoodItemModel.fromDocument(DocumentSnapshot documentSnapshot) {
    return FoodItemModel(
      name: documentSnapshot['name'],
      category: documentSnapshot['category'],
      url: documentSnapshot['url'],
      description: documentSnapshot['description'],
      price: documentSnapshot['price'],
      publishedDate: documentSnapshot['timestamp'],
      fooditemId: documentSnapshot['postId'],
      restaurantid: documentSnapshot['ownerId'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("food items");
        print(currentUser.id);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FoodDetailPage(
                    foodid: fooditemId,
                    restaurantid: restaurantid,
                    currentUserid: currentUser.id,
                  )),
        );
      },
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: MediaQuery.of(context).size.height / 3.1,
              width: 200,
              margin: EdgeInsets.only(left: 15,right: 5),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.92),
                    spreadRadius: 2,
                    blurRadius: 1,
                    offset: Offset(0, 4), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.network(
                        url,
                        fit: BoxFit.fill,
                        height: MediaQuery.of(context).size.height / 5.0,
                        width: MediaQuery.of(context).size.width / 2.52,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      name,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'Rs ',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      TextSpan(
                        text: price.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
