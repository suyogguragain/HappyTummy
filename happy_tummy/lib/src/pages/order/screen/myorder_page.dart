import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/order/screen/icon_svg.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:uuid/uuid.dart';

class MyOrderPage extends StatefulWidget {
  final String restaurantid;

  MyOrderPage({this.restaurantid});

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  Stream taskStream;
  Stream addressStream;
  Stream shippingStream;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget taskList() {
    return StreamBuilder(
      stream: taskStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 3),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        margin: EdgeInsets.only(
                            top: 10, left: 15, right: 15, bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                              width: MediaQuery.of(context).size.width / 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                  image: NetworkImage(
                                    snapshot.data.documents[index].data["url"],
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      snapshot
                                          .data.documents[index].data["name"]
                                          .substring(
                                              0,
                                              snapshot
                                                          .data
                                                          .documents[index]
                                                          .data["name"]
                                                          .length >=
                                                      20
                                                  ? (snapshot
                                                              .data
                                                              .documents[index]
                                                              .data["name"]
                                                              .length /
                                                          1.3)
                                                      .round()
                                                  : snapshot
                                                      .data
                                                      .documents[index]
                                                      .data["name"]
                                                      .length),
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: 'PermantMarker',
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.0,
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              //width: MediaQuery.of(context).size.width / 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      snapshot.data.documents[index]
                                          .data["quantity"]
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'PermantMarker',
                                          fontWeight: FontWeight.w400,
                                          letterSpacing: 0.5,
                                          color: Colors.blue)),
                                ],
                              ),
                            ),
                            Container(
                              //width: MediaQuery.of(context).size.width / 9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: '  Rs.',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: (snapshot.data.documents[index]
                                                  .data["price"] *
                                              snapshot.data.documents[index]
                                                  .data["quantity"])
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ]))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })
            : Text('');
      },
    );
  }

  Widget address() {
    return StreamBuilder(
      stream: addressStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 3),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        margin: EdgeInsets.only(
                            top: 10, left: 15, right: 15, bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Column(
                          children: [
                            Text(
                              snapshot.data.documents[index].data["address"],
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'PermantMarker',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                  color: Colors.redAccent),
                            ),
                            Text(
                              snapshot.data.documents[index].data["username"],
                              style: TextStyle(
                                fontSize: 28.0,
                                fontFamily: 'PermantMarker',
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              ),
                            ),
                            Text(
                              snapshot.data.documents[index].data["phone"]
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: 'PermantMarker',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })
            : Text('');
      },
    );
  }

  Widget shipping() {
    return StreamBuilder(
      stream: shippingStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 3),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 120,
                        margin: EdgeInsets.only(
                            top: 10, left: 15, right: 15, bottom: 5),
                        padding: EdgeInsets.only(
                            top: 10, left: 0, right: 0, bottom: 0),
                        decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Column(
                          children: [
                            Text(
                              snapshot.data.documents[index].data["message"],
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'PermantMarker',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                  color: Colors.redAccent),
                            ),
                            Text(
                              snapshot.data.documents[index].data["shippingId"],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'PermantMarker',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: Colors.blue),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:50.0,top: 10),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Order Received?',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'PermantMarker',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.5,
                                        color: Colors.green),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      print('Clicked');
                                      print(widget.restaurantid);
                                      print(currentUser.id);
                                      deleteOrder();
                                      _displaySnackBar(context);
                                    },
                                    child: Icon(
                                      Icons.sticky_note_2,
                                      color: Colors.green,
                                      size: 35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })
            : Text('');
      },
    );
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Order reset Succesful!'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  void initState() {
    getTasks(currentUser.id).then((val) {
      taskStream = val;
      setState(() {});
    });

    getAddress(currentUser.id).then((val) {
      addressStream = val;
      setState(() {});
    });

    getShipping(currentUser.id).then((val) {
      shippingStream = val;
      setState(() {});
    });

    super.initState();
  }

  getAddress(String userId) async {
    return await Firestore.instance
        .collection("order")
        .document(widget.restaurantid)
        .collection('checkout')
        .document(userId)
        .collection("address")
        .snapshots();
  }

  getShipping(String userId) async {
    return await Firestore.instance
        .collection("order")
        .document(widget.restaurantid)
        .collection('checkout')
        .document(userId)
        .collection("shipping")
        .snapshots();
  }

  getTasks(String userId) async {
    return await Firestore.instance
        .collection("order")
        .document(widget.restaurantid)
        .collection('checkout')
        .document(userId)
        .collection("foodlist")
        .snapshots();
  }

  deleteOrder() {
    Firestore.instance
        .collection('order')
        .document(widget.restaurantid)
        .collection('checkout')
        .document(currentUser.id)
        .collection('address')
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });

    Firestore.instance
        .collection('order')
        .document(widget.restaurantid)
        .collection('checkout')
        .document(currentUser.id)
        .collection('foodlist')
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });

    Firestore.instance
        .collection('order')
        .document(widget.restaurantid)
        .collection('checkout')
        .document(currentUser.id)
        .collection('shipping')
        .getDocuments()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents) {
        ds.reference.delete();
      }
    });

    Firestore.instance
        .collection('order')
        .document(widget.restaurantid)
        .collection('userlist')
        .document(currentUser.id)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Order Info",
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView(scrollDirection: Axis.vertical, children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15),
              child: Text(
                "Food Ordered ",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            taskList(),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15),
              child: Text(
                "Shipping Details ",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            address(),
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 15),
              child: Text(
                "Status ",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            shipping(),
          ],
        ),
//        Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            TimelineTile(
//              alignment: TimelineAlign.center,
//              isFirst: true,
//              indicatorStyle: const IndicatorStyle(
//                width: 20,
//                color: Colors.purple,
//                indicatorY: 0.2,
//                padding: EdgeInsets.all(8),
//              ),
//              leftChild: Container(
//                child: Column(
//                  children: [
//                    SvgPicture.asset(
//                      order_processed,
//                      height: 50,
//                      width: 50,
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      "Order Processed",
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 15,
//                          color: Colors.black),
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      "we are preparing your order",
//                      style: TextStyle(fontSize: 12, color: Colors.black),
//                    )
//                  ],
//                ),
//              ),
//            ),
//            TimelineTile(
//              alignment: TimelineAlign.center,
//              indicatorStyle: const IndicatorStyle(
//                width: 20,
//                color: Colors.yellowAccent,
//                padding: EdgeInsets.all(8),
//                indicatorY: 0.3,
//              ),
//              rightChild: Container(
//                child: Column(
//                  children: [
//                    SvgPicture.asset(
//                      order_confirmed,
//                      height: 50,
//                      width: 50,
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      "Order Confirmed",
//                      textAlign: TextAlign.center,
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 15,
//                          color: Colors.black),
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      "order has been confirmed",
//                      style: TextStyle(fontSize: 12, color: Colors.black),
//                    )
//                  ],
//                ),
//              ),
//            ),
//            TimelineTile(
//              alignment: TimelineAlign.center,
//              indicatorStyle: const IndicatorStyle(
//                width: 20,
//                color: Colors.redAccent,
//                padding: EdgeInsets.all(8),
//                indicatorY: 0.3,
//              ),
//              leftChild: Container(
//                child: Column(
//                  children: [
//                    SvgPicture.asset(
//                      order_shipped,
//                      height: 50,
//                      width: 50,
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      "Order Shipped",
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 15,
//                          color: Colors.black),
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      "order has been shipped",
//                      style: TextStyle(fontSize: 12, color: Colors.black),
//                    )
//                  ],
//                ),
//              ),
//            ),
//            TimelineTile(
//              alignment: TimelineAlign.center,
//              indicatorStyle: const IndicatorStyle(
//                width: 20,
//                color: Colors.lightBlueAccent,
//                padding: EdgeInsets.all(8),
//                indicatorY: 0.3,
//              ),
//              rightChild: Container(
//                child: Column(
//                  children: [
//                    SvgPicture.asset(
//                      order_onTheWay,
//                      height: 50,
//                      width: 50,
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      "On The Way",
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 15,
//                          color: Colors.black),
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      "order in the way",
//                      style: TextStyle(fontSize: 12, color: Colors.black),
//                    )
//                  ],
//                ),
//              ),
//            ),
//            TimelineTile(
//              alignment: TimelineAlign.center,
//              isLast: true,
//              indicatorStyle: const IndicatorStyle(
//                width: 20,
//                color: Colors.green,
//                padding: EdgeInsets.all(8),
//                indicatorY: 0.3,
//              ),
//              leftChild: Container(
//                child: Column(
//                  children: [
//                    SvgPicture.asset(
//                      order_delivered,
//                      height: 50,
//                      width: 50,
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      "Delivered",
//                      style: TextStyle(
//                          fontWeight: FontWeight.bold,
//                          fontSize: 15,
//                          color: Colors.black),
//                    ),
//                    SizedBox(
//                      height: 5,
//                    ),
//                    Text(
//                      "oh yaa!",
//                      style: TextStyle(fontSize: 12, color: Colors.black),
//                    )
//                  ],
//                ),
//              ),
//            ),
//          ],
//        ),
      ]),
    );
  }
}
