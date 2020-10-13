import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/models/menu_model.dart';

class RestaurantMenuTile extends StatefulWidget {

  final Menu post;

  RestaurantMenuTile(this.post);

  @override
  _RestaurantMenuTileState createState() => _RestaurantMenuTileState();
}

class _RestaurantMenuTileState extends State<RestaurantMenuTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 320,
      width: 200,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(widget.post.url),fit: BoxFit.cover,),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }
}