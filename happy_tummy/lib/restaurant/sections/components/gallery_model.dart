import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GalleryCard extends StatefulWidget {
  final String documentId;
  final String url;
  final String rid;
  // just press "Command + ."
  GalleryCard(this.documentId, this.url, this.rid);

  @override
  _GalleryCardState createState() => _GalleryCardState();
}

class _GalleryCardState extends State<GalleryCard> {
  bool isHover = false;

  deleteTask(String userId, String documentId) {
    Firestore.instance
        .collection("gallery")
        .document(userId)
        .collection("restaurantGallery")
        .document(documentId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(scrollDirection: Axis.vertical,children: [
      Container(
        height: 160,
        width: 200,
        child: Row(
          children: [
            Image.network(widget.url),
            Positioned(
              left: 0,
              top: 0,
              child: GestureDetector(
                onTap: () {
                  deleteTask(widget.rid, widget.documentId);
                },
                child: Text(
                  "Delete",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
