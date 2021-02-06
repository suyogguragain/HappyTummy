import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class BookedEvents extends StatefulWidget {
  final String restaurantid, eventid;

  BookedEvents({this.restaurantid, this.eventid});

  @override
  _BookedEventsState createState() => _BookedEventsState();
}

class _BookedEventsState extends State<BookedEvents> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
        title: Text(
          "Booked Events",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "PermanentMarker",
            fontSize: 32.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: FutureBuilder(
          future: retrieveNotifications(),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return circularProgress();
            }
            return ListView(
              children: dataSnapshot.data,
            );
          },
        ),
      ),
    );
  }

  retrieveNotifications() async {
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection('bookevents')
        .document(widget.restaurantid)
        .collection("feedItems")
        .where('eventId', isEqualTo: widget.eventid)
        .limit(60)
        .getDocuments();

    List<NoticationsItem> notificationsItems = [];

    querySnapshot.documents.forEach((document) {
      notificationsItems.add(NoticationsItem.fromDocument(document));
    });

    return notificationsItems;
  }
}

class NoticationsItem extends StatelessWidget {
  final String username;
  final String type;
  final String eventId;
  final String userId;
  final String userProfileImg;
  final Timestamp timestamp;
  final String heading;
  final String location;

  NoticationsItem({
    this.location,
    this.heading,
    this.username,
    this.type,
    this.userId,
    this.eventId,
    this.userProfileImg,
    this.timestamp,
  });

  factory NoticationsItem.fromDocument(DocumentSnapshot documentSnapshot) {
    return NoticationsItem(
      username: documentSnapshot['username'],
      location: documentSnapshot['location'],
      type: documentSnapshot['type'],
      eventId: documentSnapshot['postId'],
      userId: documentSnapshot['userId'],
      userProfileImg: documentSnapshot['userProfileImg'],
      timestamp: documentSnapshot['timestamp'],
      heading: documentSnapshot['heading'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.0, top: 5, left: 10, right: 10),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                height: 50.0,
                width: 50.0,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(userProfileImg)),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  '$username booked seat for $heading  from $location',
                  style: TextStyle(fontFamily: "Roboto", fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
