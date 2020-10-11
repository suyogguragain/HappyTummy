import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/panaroma.dart';

class RestaurantDetails extends StatefulWidget {
  final DocumentSnapshot restaurant;

  RestaurantDetails({this.restaurant});

  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails>
    with SingleTickerProviderStateMixin {
  TabController _controller;
  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3, vsync: this);
  }

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
        backgroundColor: Colors.black,
        title: Text(
          widget.restaurant.data['name'],
          style: TextStyle(fontFamily: "Lobster", fontSize: 25),
        ),
      ),
      body: ListView(
        children: [
          Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 260.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    widget.restaurant.data['photo']),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black87,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  widget.restaurant.data['name'],
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.white),
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 70,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Row(
                                  children: [
                                    Text(
                                      'Rating',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 15,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 10),
                                  child: Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 7),
                                  child: Text(
                                    widget.restaurant.data['location'],
                                    style: TextStyle(
                                        fontSize: 17.0, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                            thickness: 2,
                            indent: 20,
                            endIndent: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 20, top: 10),
                                  child: Icon(
                                    Icons.phone,
                                    color: Colors.blue,
                                    size: 20,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, top: 7),
                                  child: Text(
                                    '091895327829',
                                    style: TextStyle(
                                        fontSize: 17.0, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                            thickness: 2,
                            indent: 20,
                            endIndent: 20,
                          ),
                          SizedBox(height: 20,),
                          DefaultTabController(
                            length: 3,
                            initialIndex: 0,
                            child: Container(
                              child: TabBar(
                                controller: _controller,
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.white,
                                indicatorColor: Colors.white,
                                tabs: [
                                  Tab(child: Text("About",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),),
                                  Tab(child: Text("Reviews",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),),
                                  Tab(child: Text("Opening Hours",style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),),),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 80,
                      child: TabBarView(
                        controller: _controller,
                        children: [
                          Text('Hero'),
                          Text('Hero 4556'),
                          Text('Hero 3'),
                        ],
                      ),
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
                            SizedBox(
                              width: 100,
                            ),
                            Text(
                              "Cusines",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54),
                            ),
                            SizedBox(
                              width: 10,
                            ),
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
                            SizedBox(
                              width: 100,
                            ),
                            Text(
                              "Mealtype",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.restaurant.data['mealtype'],
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
                            SizedBox(
                              width: 100,
                            ),
                            Text(
                              "Outlettype",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.restaurant.data['outlettype'],
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
                            SizedBox(
                              width: 100,
                            ),
                            Text(
                              "Billing Extra",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54),
                            ),
                            SizedBox(
                              width: 10,
                            ),
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
                            SizedBox(
                              width: 100,
                            ),
                            Text(
                              "Parking",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54),
                            ),
                            SizedBox(
                              width: 10,
                            ),
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
                            SizedBox(
                              width: 100,
                            ),
                            Text(
                              "Payment Method",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white54),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              widget.restaurant.data['paymentmethod'],
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
                      ],
                    ),
                  ],
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
                  alignment: Alignment(1.3, -2.1),
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
