import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/models/food_model.dart';

class MenuTile extends StatefulWidget {
  final FoodItem post;

  MenuTile(this.post);

  @override
  _MenuTileState createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  deleteTask(String userId, String documentId) {
    Firestore.instance
        .collection("restarurantMenu")
        .document(userId)
        .collection("restaurantFoodItems")
        .document(documentId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 20, top: 10),
          color: Colors.white24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.post.url),
                radius: 50.0,
              ),
              
              Container(
                color: Colors.white,
                margin: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Text(
                      widget.post.name,
                      style: const TextStyle(fontSize: 17, color: Colors.black),
                    ),
                    Text(
                      widget.post.desc.substring(0, 20),
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                    Text(
                      "\$ ${widget.post.price}",
                      style: const TextStyle(
                          fontSize: 25,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
              ),
              SizedBox(
                width: 16,
              ),
              GestureDetector(
                  onTap: () {
                    deleteTask(widget.post.ownerId, widget.post.postId);
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
