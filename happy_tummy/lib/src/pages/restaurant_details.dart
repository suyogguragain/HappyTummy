import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/panaroma.dart';

class RestaurantDetails extends StatefulWidget {
  final DocumentSnapshot restaurant;

  RestaurantDetails({this.restaurant});

  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  createOrientation() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            child: Image.asset('assets/images/ht.png'),
          ),
          Text(
            "Happy Tummy",
            style: TextStyle(
                fontFamily: "Lobster",
                fontSize: 21.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(
          widget.restaurant.data['name'],
          style: TextStyle(fontFamily: "Lobster", fontSize: 25),
        ),
      ),
      body: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.orange.shade300, Colors.orange.shade900]),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 350.0,
                            height: 240.0,
                            decoration: BoxDecoration(
                               // shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white60, width: 2.0)),
                            padding: EdgeInsets.all(8.0),
//                            child: CircleAvatar(
//                              backgroundImage:
//                                  NetworkImage(widget.restaurant.data['photo']),
//                            ),
                          child: Image.network(widget.restaurant.data['photo'],width: 350,height: 220,fit: BoxFit.cover,),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        widget.restaurant.data['name'],
                        style: TextStyle(
                            fontSize: 21.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        widget.restaurant.data['location'],
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white54),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      MaterialButton(
                        onPressed: () {},
                        color: Colors.black87,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text(
                          "Restaurant Detail",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 100,),
                              Text(
                                "Cusines",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                widget.restaurant.data['cusines'],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 100,),
                              Text(
                                "Mealtype",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                widget.restaurant.data['mealtype'],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                            ],
                          ),SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 100,),
                              Text(
                                "Outlettype",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                widget.restaurant.data['outlettype'],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                            ],
                          ),SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 100,),
                              Text(
                                "Billing Extra",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                widget.restaurant.data['billingextra'],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 100,),
                              Text(
                                "Parking",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                widget.restaurant.data['parking'],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 100,),
                              Text(
                                "Payment Method",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                widget.restaurant.data['paymentmethod'],
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white54),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment(1.5, -1.1),
                  child: Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white24,
                      )),
                ),
                Align(
                  alignment: Alignment(1.3,-2.1),
                  child: Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white24,
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.settings,
                        color: Colors.white24,
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 590.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print("Gallery");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                              height: 130,
                              width: 200,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Gallery',
                                style: TextStyle(
                                    fontSize: 38.0,
                                    fontFamily: "Lobster",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("Review");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 130,
                              width: 200,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Review',
                                style: TextStyle(
                                    fontSize: 38.0,
                                    fontFamily: "Lobster",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print("Menu");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 130,
                              width: 200,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Menu',
                                style: TextStyle(
                                    fontSize: 38.0,
                                    fontFamily: "Lobster",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              print("VR");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PanoramaPage(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 130,
                              width: 200,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'VR',
                                style: TextStyle(
                                    fontSize: 38.0,
                                    fontFamily: "Lobster",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 2,
          ),
          createOrientation(),
          Divider(
            thickness: 2,
          ),
        ],
      ),
    );
  }
}
