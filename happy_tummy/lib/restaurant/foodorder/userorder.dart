import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:happy_tummy/src/pages/order/screen/icon_svg.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:uuid/uuid.dart';

class UserOrder extends StatefulWidget {
  final String restaurantid;
  final String userid;

  UserOrder({this.restaurantid, this.userid});

  @override
  _UserOrderState createState() => _UserOrderState();
}

class _UserOrderState extends State<UserOrder> {
  Stream taskStream;
  Stream addressStream;
  String shippingId = Uuid().v4();
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
                              // width: MediaQuery.of(context).size.width ,
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
                              // width: MediaQuery.of(context).size.width ,
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

  @override
  void initState() {
    getTasks().then((val) {
      taskStream = val;
      setState(() {});
    });

    getAddress().then((val) {
      addressStream = val;
      setState(() {});
    });

    super.initState();
  }

  getAddress() async {
    return await Firestore.instance
        .collection("order")
        .document(widget.restaurantid)
        .collection('checkout')
        .document(widget.userid)
        .collection("address")
        .snapshots();
  }

  getTasks() async {
    return await Firestore.instance
        .collection("order")
        .document(widget.restaurantid)
        .collection('checkout')
        .document(widget.userid)
        .collection("foodlist")
        .snapshots();
  }

  OrderShipped() {
    Firestore.instance
        .collection('order')
        .document(widget.restaurantid)
        .collection('checkout')
        .document(widget.userid)
        .collection('shipping')
        .document(shippingId)
        .setData({
      'shippingId': shippingId,
      'timestamp': DateTime.now(),
      'restaurantId': widget.restaurantid,
      'message': "Your order has been shipped! ",
    });
  }

  _displaySnackBar(BuildContext context) {
    final snackBar = SnackBar(content: Text('Shipping details send successfully.'));
    _scaffoldKey.currentState.showSnackBar(snackBar);
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
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 5),
              padding: EdgeInsets.only(left: 20),
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
                  Text(
                    'If Order has been Shipped!! (click here->)',
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'PermantMarker',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                        color: Colors.green),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('Clicked');
                      print(widget.restaurantid);
                      OrderShipped();
                      _displaySnackBar(context);
                    },
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: Colors.red,
                      size: 35,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}
