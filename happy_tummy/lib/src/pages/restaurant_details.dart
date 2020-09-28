import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantDetails extends StatefulWidget {
  final DocumentSnapshot restaurant;

  RestaurantDetails({this.restaurant});

  @override
  _RestaurantDetailsState createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  String postOrientation = "gallery";

  createOrientation() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 10.0, left: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.grid_on),
            tooltip: 'gallery',
            onPressed: () => print('gallery'),
            color: postOrientation == 'gallery'
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
          IconButton(
            icon: Icon(Icons.rate_review),
            onPressed: () => print('review'),
            color: postOrientation == 'review'
                ? Theme.of(context).primaryColor
                : Colors.grey,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: Text(widget.restaurant.data['name']),
      ),
      body: ListView(
        children: [
          Card(
            child: Column(
              children: [
                Text(widget.restaurant.data['name']),
                Text(widget.restaurant.data['parking']),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            thickness: 2,
          ),
          createOrientation(),
          Divider(
            thickness: 2,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: RaisedButton(
              onPressed: () => print('menu'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
              color: Colors.pink,
              elevation: 2.0,
              textColor: Colors.black,
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 40.0, right: 40.0),
              child: Text(
                'Food Menu',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: RaisedButton(
              onPressed: () => print('VR'),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              color: Colors.pink,
              elevation: 2.0,
              textColor: Colors.black,
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 40.0, right: 40.0),
              child: Text(
                'Virtual Restaurant',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
