import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/models/menu_model.dart';

class MenuTile extends StatefulWidget {

  final Menu post;

  MenuTile(this.post);

  @override
  _MenuTileState createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  deleteTask(String userId, String documentId) {
    Firestore.instance
        .collection("restarurantMenu")
        .document(userId)
        .collection("restaurantMenu")
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
          color: Colors.white24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(widget.post.url),
                radius: 50.0,
              ),
              GestureDetector(
                onTap: () {
                  deleteTask(widget.post.ownerId, widget.post.postId);
                },
                child: Icon(Icons.delete,color: Colors.red,)
              ),
            ],
          ),
        ),
      ],
    );
  }
}