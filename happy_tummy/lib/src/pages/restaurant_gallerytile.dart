import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/models/gallery_model.dart';

class RestaurantGalleryTile extends StatefulWidget {

  final Gallery post;

  RestaurantGalleryTile(this.post);

  @override
  _RestaurantGalleryTileState createState() => _RestaurantGalleryTileState();
}

class _RestaurantGalleryTileState extends State<RestaurantGalleryTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 120,
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
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