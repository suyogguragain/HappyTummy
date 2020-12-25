//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
//import 'package:happy_tummy/src/models/fooditem_model.dart';
//import 'package:happy_tummy/src/pages/order/widget/orderSearchBox.dart';
//import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
//
//class OrderFoodList extends StatefulWidget {
//  final DocumentSnapshot restaurant;
//
//  OrderFoodList({this.restaurant});
//
//  @override
//  _OrderFoodListState createState() => _OrderFoodListState();
//}
//
//class _OrderFoodListState extends State<OrderFoodList> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text(
//          "Food Menu",
//        ),
//        backgroundColor: Colors.black,
//        centerTitle: true,
//        actions: [
//          Padding(
//            padding: const EdgeInsets.only(right: 18.0),
//            child: GestureDetector(
//              child: Icon(
//                Icons.add_shopping_cart,
//                color: Colors.white,
//                size: 27,
//              ),
//              onTap: () {
//                print('cart');
//              },
//            ),
//          ),
//        ],
//      ),
//      body: CustomScrollView(
//        slivers: [
//          SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
////          StreamBuilder<QuerySnapshot>(
////            stream: Firestore.instance.collection('restarurantMenu').document(widget.restaurant.data['rid']).collection('restaurantFoodItems').limit(15).orderBy("timestamp",descending: true).snapshots(),
////            builder: (context,dataSnapshot){
////              return !dataSnapshot.hasData
////                  ? SliverToBoxAdapter(child: Center(child: circularProgress(),),)
////                  : SliverStaggeredGrid.countBuilder(crossAxisCount: 1,  staggeredTileBuilder: (c) => StaggeredTile.fit(1), itemBuilder: (context,index){
////                    FoodItemModel model = FoodItemModel.fromJson(dataSnapshot.data.documents[index].data);
////                    return sourceInfo(model,context);
////              },
////                itemCount: dataSnapshot.data.documents.length,
////              );
////            },
////          )
//        Text(widget.restaurant.data['name']),
//        ],
//      ),
//    );
//  }
//}
////
////Widget sourceInfo (FoodItemModel model, BuildContext context, {Color background, removeCartFunction}){
////  return InkWell(
////    splashColor: Colors.pink,
////    child: Padding(
////      padding: EdgeInsets.all(6),
////      child: Container(
////        height: 190.0,
////        width: MediaQuery.of(context).size.width,
////        child: Row(
////          children: [
////            Image.network(model.url,width: 140.0,height: 140.0,),
////            SizedBox(width: 4.0,),
////
////          ],
////        ),
////      ),
////    ),
////  );
////}
//
//
////////////////////
//
//
//
//

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/fooditem_model.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class OrderFoodList extends StatefulWidget {
  final DocumentSnapshot restaurant;

  OrderFoodList({this.restaurant});

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


  retrieveFoodItems() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('restarurantMenu')
          .document(widget.restaurant.data['rid'])
          .collection('restaurantFoodItems')
          .orderBy("timestamp", descending: false)
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18.0),
            child: GestureDetector(
              child: Icon(
                Icons.add_shopping_cart,
                color: Colors.white,
                size: 27,
              ),
              onTap: () {
                print('cart');
              },
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              print('searchfood');
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//              builder: (context) => SearchFoodItem(),
//            ),
//          );
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
              width: MediaQuery.of(context).size.width,
              height: 80.0,
              child: InkWell(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  width: MediaQuery.of(context).size.width,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.search,
                          color: Colors.blueGrey,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text("Search here"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            child: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      child: Container(
                        child: retrieveFoodItems(),
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
