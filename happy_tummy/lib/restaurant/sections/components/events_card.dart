import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/sections/components/constants.dart';


class EventsCard extends StatefulWidget {
  final String description;
  final String heading;
  final String ownerId;
  final String documentId;
  // just press "Command + ."
  EventsCard(this.description, this.documentId, this.heading, this.ownerId);

  @override
  _EventsCardState createState() => _EventsCardState();
}

class _EventsCardState extends State<EventsCard> {
  bool isHover = false;

  deleteTask(String userId, String documentId) {
    Firestore.instance
        .collection("events")
        .document(userId)
        .collection("userPosts")
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
        height: 160,
        width: 400,
        margin: EdgeInsets.only(left: 45, bottom: 50, right: 50),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [if (isHover) kDefaultCardShadow],
        ),
        child: Row(
          children: [
            Image.asset('assets/images/work_1.png'),
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
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    SizedBox(height: kDefaultPadding),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                deleteTask(widget.ownerId, widget.documentId);
              },
              child: Icon(
                Icons.delete,
                color: Colors.red,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
