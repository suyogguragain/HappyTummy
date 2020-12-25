import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/fooditem_model.dart';

class FoodDetailPage extends StatefulWidget {
  final String foodid;

  FoodDetailPage({this.foodid});

  @override
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Food Details",
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(widget.foodid),
          )
        ],
      ),
    );
  }
}
