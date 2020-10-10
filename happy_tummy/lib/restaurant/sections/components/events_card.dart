import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/sections/components/constants.dart';


class EventsCard extends StatefulWidget {
  final String description;
  final String heading;
  final String ownerId;
  final String documentId;
  final String date;
  final String totalseat;
  final String location;
  // just press "Command + ."
  EventsCard(this.description, this.documentId, this.heading, this.ownerId,this.date,this.totalseat,this.location);

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
        height: 180,
        width: 400,
        margin: EdgeInsets.only(left: 35, bottom: 50, right: 35),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(width: 144,
                child: Image.asset('assets/images/work_1.png')),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.heading.toUpperCase(),style: TextStyle(color: Colors.white, fontSize: 12)),
                    SizedBox(height: kDefaultPadding / 2),
                    Text(
                      widget.description,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Total Seat: ${widget.totalseat}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/location.png",
                          height: 12,
                        ),
                        SizedBox(width: 5),
                        Text(
                          widget.date,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/calender.png",
                          height: 12,
                        ),
                        SizedBox(width: 5),
                        Text(
                          widget.location,
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Booked Seat: ${widget.totalseat}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
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
