import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/order/widget/orderSearchBox.dart';

class OrderFoodList extends StatefulWidget {
  @override
  _OrderFoodListState createState() => _OrderFoodListState();
}

class _OrderFoodListState extends State<OrderFoodList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food Menu",
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
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(pinned: true, delegate: SearchBoxDelegate()),
        ],
      ),
    );
  }
}
