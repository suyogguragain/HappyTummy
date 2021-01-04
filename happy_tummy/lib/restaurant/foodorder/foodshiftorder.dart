import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:happy_tummy/restaurant/foodorder/userorder.dart';
import 'package:happy_tummy/src/pages/order/screen/orderrestaurantlist.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class FoodShiftOrders extends StatefulWidget {
  final String restaurantProfileId;

  FoodShiftOrders({this.restaurantProfileId});
  @override
  _MyOrdersState createState() => _MyOrdersState();
}


class _MyOrdersState extends State<FoodShiftOrders> {
  Future _data;

  Future getusers() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection('users').getDocuments();

    return qn.documents;
  }

  navigateToDetail(String id, String restaurantid) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserOrder(restaurantid: restaurantid,userid: id,)
      ),
    );
  print(id);
  }

  @override
  void initState() {
    super.initState();
    _data = getusers();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "User List"),
      body: ListView(
        children: [
          //fetch restaurant form firestore
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
                future: _data,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                    return ListView.builder(
                       // scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return Container(
                            margin:
                            EdgeInsets.only(top: 10, left: 10, right: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                           // margin: EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () => navigateToDetail(snapshot.data[index].data['id'],widget.restaurantProfileId),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.black54,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                    bottomLeft: Radius.circular(30),
                                    bottomRight: Radius.circular(30),
                                  ),
                                ),
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(
                                    snapshot.data[index].data['profileName'],
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }
}
