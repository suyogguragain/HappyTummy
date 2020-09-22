import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class MenuCard extends StatefulWidget {
  final String price;
  final String name;
  final String ownerId;
  final String documentId;
  // just press "Command + ."
  MenuCard(this.price, this.documentId, this.name, this.ownerId);

  @override
  _MenuCardState createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {
  bool isHover = false;

  deleteTask(String userId, String documentId) {
    Firestore.instance
        .collection("restarurantMenu")
        .document(userId)
        .collection("menulist")
        .document(documentId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {
        setState(() {
          isHover = value;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        height: 80,
        width: 200,
        margin: EdgeInsets.only(left: 130, bottom: 20, right: 115),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [if (isHover) kDefaultCardShadow],
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.name.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          .copyWith(height: 1.5),
                    ),
                    SizedBox(height: kDefaultPadding / 2),
                    Text(
                      widget.price,
                      style: Theme.of(context)
                          .textTheme
                          .headline2
                          .copyWith(height: 1.5),
                    ),
                    SizedBox(height: kDefaultPadding),
                    GestureDetector(
                      onTap: () {
                        deleteTask(widget.ownerId, widget.documentId);
                      },
                      child: Icon(Icons.close,
                          size: 43, color: Colors.redAccent.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
