import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/fooditem_model.dart';
import 'package:happy_tummy/src/pages/order/screen/myorder_page.dart';
import 'package:happy_tummy/src/pages/order/screen/ordercart.dart';
import 'package:happy_tummy/src/pages/order/widget/orderSearchBox.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class OrderFoodList extends StatefulWidget {
  final DocumentSnapshot restaurant;
  final String currentUser;

  OrderFoodList({this.restaurant, this.currentUser});

  @override
  _OrderFoodListState createState() => _OrderFoodListState();
}

class _OrderFoodListState extends State<OrderFoodList>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  int countPost = 0;

  @override
  void initState() {
    super.initState();
  }

  retrieveFoodItems(String str) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('restarurantMenu')
          .document(widget.restaurant.data['rid'])
          .collection('restaurantFoodItems')
          .orderBy("timestamp", descending: false)
          .where('category', isEqualTo: str)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<FoodItemModel> fooditem = [];
        dataSnapshot.data.documents.forEach((document) {
          fooditem.add(FoodItemModel.fromDocument(document));
        });
        return ListView(
          scrollDirection: Axis.horizontal,
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
          "${widget.restaurant.data['name']}'s Menu",
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Row(
            children: [
//              InkWell(
//                onTap: () {
//                  print('searchfood');
////                  Navigator.push(
////                    context,
////                    MaterialPageRoute(
////                      builder: (context) => SearchFood(
////                        restaurantid: widget.restaurant.data['rid'],
////                      ),
////                    ),
////                  );
//                },
//                child: Container(
//                  decoration: BoxDecoration(
//                    gradient: LinearGradient(
//                      colors: [Colors.black, Colors.black],
//                      begin: FractionalOffset(0.0, 0.0),
//                      end: FractionalOffset(1.0, 0.0),
//                      stops: [0.0, 1.0],
//                      tileMode: TileMode.clamp,
//                    ),
//                  ),
//                  alignment: Alignment.center,
//                  width: MediaQuery.of(context).size.width * 0.7,
//                  height: 80.0,
//                  child: InkWell(
//                    child: Container(
//                      margin: EdgeInsets.only(left: 10, right: 10),
//                      width: MediaQuery.of(context).size.width,
//                      height: 50.0,
//                      decoration: BoxDecoration(
//                        color: Colors.white,
//                        borderRadius: BorderRadius.circular(6),
//                      ),
//                      child: Row(
//                        children: [
//                          Padding(
//                            padding: EdgeInsets.only(left: 8),
//                            child: Icon(
//                              Icons.search,
//                              color: Colors.blueGrey,
//                            ),
//                          ),
//                          Padding(
//                            padding: EdgeInsets.only(left: 8),
//                            child: Text("Search here"),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ),

              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderCart(
                        restaurantid: widget.restaurant.data['rid'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 60.0,
                  child: InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_shopping_cart,
                              color: Colors.black,
                              size: 27,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Cart",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyOrderPage(restaurantid: widget.restaurant.data['rid'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black, Colors.black],
                      begin: FractionalOffset(0.0, 0.0),
                      end: FractionalOffset(1.0, 0.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp,
                    ),
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 60.0,
                  child: InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width,
                      height: 45.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.offline_pin,
                              color: Colors.black,
                              size: 27,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "My Order",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: 260,
                      child: Container(
                        child: retrieveFoodItems('pasta'),
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 260,
                      child: Container(
                        child: retrieveFoodItems("vegeterian"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 260,
                      child: Container(
                        child: retrieveFoodItems("beverges"),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 260,
                      child: Container(
                        child: retrieveFoodItems("momo"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
