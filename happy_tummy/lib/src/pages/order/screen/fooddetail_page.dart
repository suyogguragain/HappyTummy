import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/fooditem_model.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/profile_page.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:uuid/uuid.dart';

class FoodDetailPage extends StatefulWidget {
  final String foodid;
  final String restaurantid;
  final String currentUserid;

  FoodDetailPage({this.foodid, this.restaurantid, this.currentUserid});

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  retrieveFoodItems() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('restarurantMenu')
          .document(widget.restaurantid)
          .collection('restaurantFoodItems')
          .where('postId', isEqualTo: widget.foodid)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<FoodItemIndividualModel> fooditem = [];
        dataSnapshot.data.documents.forEach((document) {
          fooditem.add(FoodItemIndividualModel.fromDocument(document));
        });
        return ListView(
          children: fooditem,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food Details",
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Container(
          child: retrieveFoodItems(),
        ),
      ),
    );
  }
}

class FoodItemIndividualModel extends StatefulWidget {
  String name;
  String description;
  Timestamp publishedDate;
  String url;
  String category;
  int price;
  String fooditemId;
  String restaurantid;

  FoodItemIndividualModel({
    this.name,
    this.description,
    this.publishedDate,
    this.url,
    this.category,
    this.price,
    this.fooditemId,
    this.restaurantid,
  });

  factory FoodItemIndividualModel.fromDocument(
      DocumentSnapshot documentSnapshot) {
    return FoodItemIndividualModel(
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
  _FoodItemIndividualModelState createState() =>
      _FoodItemIndividualModelState();
}

class _FoodItemIndividualModelState extends State<FoodItemIndividualModel> {
  int _quantity = 1;
  String postId = Uuid().v4();

  savePostInfoToFireStore(int quantity) {
    Firestore.instance
        .collection('foodcart')
        .document(currentUser.id)
        .collection('Cart')
        .document(widget.restaurantid)
        .collection('foodlist')
        .document(postId)
        .setData({
      'cartId': postId,
      'ownerId': currentUser.id,
      'timestamp': DateTime.now(),
      'restaurantId': widget.restaurantid,
      'foodId': widget.fooditemId,
      'quantity': quantity,
      'name': widget.name,
      'url': widget.url,
      'price': widget.price
    });

    Firestore.instance
        .collection('order')
        .document(widget.restaurantid)
        .collection('checkout')
        .document(currentUser.id)
        .collection('foodlist')
        .document(postId)
        .setData({
      'cartId': postId,
      'ownerId': currentUser.id,
      'timestamp': DateTime.now(),
      'restaurantId': widget.restaurantid,
      'foodId': widget.fooditemId,
      'quantity': quantity,
      'name': widget.name,
      'url': widget.url,
      'price': widget.price
    });

    setState(() {
      postId = Uuid().v4();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: Center(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: EdgeInsets.only(top: 100, bottom: 100),
                padding: EdgeInsets.only(top: 100, bottom: 100),
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Poppins')),
                    SizedBox(height: 10),
                    Text('Rs. ${widget.price.toString()}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 28,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Poppins')),
                    SizedBox(height: 10),
                    Text(widget.description,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Poppins')),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 25),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Text('Quantity'),
                            margin: EdgeInsets.only(bottom: 15),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 55,
                                height: 55,
                                child: OutlineButton(
                                  onPressed: () {
                                    setState(() {
                                      _quantity += 1;
                                    });
                                  },
                                  child: Icon(Icons.add),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  _quantity.toString(),
                                ),
                              ),
                              Container(
                                width: 55,
                                height: 55,
                                child: OutlineButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_quantity == 1) return;
                                      _quantity -= 1;
                                    });
                                  },
                                  child: Icon(Icons.remove),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 180,
                      child: FlatButton(
                        onPressed: () {
                          print('cart');
                          savePostInfoToFireStore(_quantity);
                          final snackBar = SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(
                              'Item has been added to Cart.',
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                          Scaffold.of(context)
                              .showSnackBar(snackBar);
                        },
                        child: Text("Add to Cart",
                            style:
                                TextStyle(color: Colors.white, fontSize: 22)),
                        textColor: Colors.white,
                        color: Colors.black87,
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 15,
                          spreadRadius: 5,
                          color: Color.fromRGBO(0, 0, 0, .05))
                    ]),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 200,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    widget.url,
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
