import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/order/screen/fooddetail_page.dart';

class FoodItemModel extends StatelessWidget {
  String name;
  String description;
  Timestamp publishedDate;
  String url;
  String category;
  int price;
  String fooditemId;

  FoodItemModel({
    this.name,
    this.description,
    this.publishedDate,
    this.url,
    this.category,
    this.price,
    this.fooditemId,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("food items");
//        Route route = MaterialPageRoute(builder: (c)=> FoodDetailPage(foodid: fooditemId));
//        Navigator.pushReplacement(context, route);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FoodDetailPage(foodid: fooditemId)),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 6.0, top: 10),
        child: Container(
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 1,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 60,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        )),
                  ),
                  Container(
                    height: 60,
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            name,
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black54,
                                fontFamily: "Lobster"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: Text(
                  description,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
