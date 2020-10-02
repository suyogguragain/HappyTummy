import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/models/gallery_model.dart';

class GalleryTile extends StatefulWidget {

  final Gallery post;

  GalleryTile(this.post);

  @override
  _GalleryTileState createState() => _GalleryTileState();
}

class _GalleryTileState extends State<GalleryTile> {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(widget.post.url),
              radius: 55.0,
            ),
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  deleteTask(widget.post.ownerId, widget.post.postId);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}