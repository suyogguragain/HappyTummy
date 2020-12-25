import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/order/screen/orderfoodlist.dart';
import 'package:happy_tummy/src/pages/order/screen/orderrestaurantlist.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class RestaurantListPage extends StatefulWidget {
  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> { Future _data;

Future getrestaurants() async {
  var firestore = Firestore.instance;

  QuerySnapshot qn = await firestore.collection('restaurants').getDocuments();

  return qn.documents;
}

navigateToDetail(DocumentSnapshot restaurant) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => OrderFoodList(
        restaurant: restaurant,
      ),
    ),
  );
}


@override
void initState() {
  super.initState();
  _data = getrestaurants();
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Happy Tummy"),
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
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return Container(
                            margin: EdgeInsets.only(top: 10,left: 10,right: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                            //margin: EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () =>
                                  navigateToDetail(snapshot.data[index]),
//                                                            onTap: () =>
//                                  navigateToDetail(),
                              child: OrderSectionRestaurantList(
                                  id: snapshot.data[index].data['rid'],
                                  name: snapshot.data[index].data['name'],
                                  imagePath: snapshot.data[index].data['photo'],
                                  location:
                                  snapshot.data[index].data['location']),
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
