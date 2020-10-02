import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MenuCard extends StatefulWidget {
  final String documentId;
  final String url;
  final String rid;
  // just press "Command + ."
  MenuCard(this.documentId, this.url, this.rid);

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  bool isHover = false;

  deleteTask(String userId, String documentId) {
    Firestore.instance
        .collection("menu")
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
    return GridView(scrollDirection: Axis.vertical,children: [
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
