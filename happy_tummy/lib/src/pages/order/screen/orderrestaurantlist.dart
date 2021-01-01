import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderSectionRestaurantList extends StatefulWidget {
  final String id;
  final String name;
  final String imagePath;
  final String location;

  OrderSectionRestaurantList(
      {this.id, this.name, this.imagePath, this.location});

  @override
  _OrderSectionRestaurantListState createState() =>
      _OrderSectionRestaurantListState();
}

class _OrderSectionRestaurantListState
    extends State<OrderSectionRestaurantList> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: 110.0,
            width: MediaQuery.of(context).size.width ,
            child: Image.network(
              widget.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Container(
              height: 60.0,
              width: 360.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.black12],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
              ),
            ),
          ),
          Positioned(
            left: 10.0,
            bottom: 10.0,
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          widget.location,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.black12],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter),
              ),
              height: 110.0,
              width: MediaQuery.of(context).size.width * 0.1,
              child: Icon(Icons.arrow_right,color: Colors.white,size: 50,),
            ),
          )
        ],
      ),
    );
  }
}
