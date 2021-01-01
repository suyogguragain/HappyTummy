import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';

class MyOrderPage extends StatefulWidget {
  final String restaurantid;

  MyOrderPage({this.restaurantid});

  @override
  _MyOrderPageState createState() => _MyOrderPageState();
}

class _MyOrderPageState extends State<MyOrderPage> {
  Stream taskStream;
  Stream addressStream;

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
                              width: MediaQuery.of(context).size.width / 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      snapshot
                                          .data.documents[index].data["name"],
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
                              width: MediaQuery.of(context).size.width / 8,
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
                              width: MediaQuery.of(context).size.width / 9,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: 'Rs.',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text: snapshot
                                          .data.documents[index].data["price"]
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
    getTasks(currentUser.id).then((val) {
      taskStream = val;
      setState(() {});
    });

    getAddress(currentUser.id).then((val) {
      addressStream = val;
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

  getTasks(String userId) async {
    return await Firestore.instance
        .collection("order")
        .document(widget.restaurantid)
        .collection('checkout')
        .document(userId)
        .collection("foodlist")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            address(),
          ],
        ),
      ]),
    );
  }
}
