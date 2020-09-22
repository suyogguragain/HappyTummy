import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class OfferCard extends StatefulWidget {
  final String description;
  final String heading;
  final String ownerId;
  final String documentId;
  // just press "Command + ."
  OfferCard(this.description, this.documentId, this.heading, this.ownerId);

  @override
  _OfferCardState createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool isHover = false;

  deleteTask(String userId, String documentId) {
    Firestore.instance
        .collection("offers")
        .document(userId)
        .collection("restarurantOffers")
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
        height: 320,
        width: 540,
        margin: EdgeInsets.only(left: 130, bottom: 50, right: 115),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [if (isHover) kDefaultCardShadow],
        ),
        child: Row(
          children: [
            Image.asset('assets/images/work_4.png'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.heading.toUpperCase()),
                    SizedBox(height: kDefaultPadding / 2),
                    Text(
                      widget.description,
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(height: 1.5),
                    ),
                    SizedBox(height: kDefaultPadding),
                    GestureDetector(
                      onTap: () {
                        deleteTask(widget.ownerId, widget.documentId);
                      },
                      child: Text(
                        "Delete Offer",
                        style: TextStyle(decoration: TextDecoration.underline),
                      ),
                    )
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
