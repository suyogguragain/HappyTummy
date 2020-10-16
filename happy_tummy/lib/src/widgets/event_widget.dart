import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/profile_page.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class Event extends StatefulWidget {
  final String eventId;
  final String ownerId;
  final dynamic bookevents;
  final String date;
  final String description;
  final String location;
  final String heading;
  final String totalseat;

  Event({
    this.eventId,
    this.ownerId,
    this.bookevents,
    this.date,
    this.description,
    this.location,
    this.heading,
    this.totalseat,
  });

  factory Event.fromDocument(DocumentSnapshot documentSnapshot) {
    return Event(
      eventId: documentSnapshot['eventId'],
      ownerId: documentSnapshot['ownerId'],
      bookevents: documentSnapshot['bookevent'],
      date: documentSnapshot['date'],
      description: documentSnapshot['description'],
      location: documentSnapshot['location'],
      heading: documentSnapshot['heading'],
      totalseat: documentSnapshot['totalseat'],
    );
  }

  int getTotalNumberOfSeats(seats) {
    if (seats == null) {
      return 0;
    }

    int counter = 0;
    seats.values.forEach((eachValue) {
      if (eachValue == true) {
        counter = counter + 1;
      }
    });
    return counter;
  }

  @override
  _EventState createState() => _EventState(
        eventId: this.eventId,
        ownerId: this.ownerId,
        bookevents: this.bookevents,
        date: this.date,
        description: this.description,
        location: this.location,
        heading: this.heading,
        totalseat: this.totalseat,
        EventCount: getTotalNumberOfSeats(this.bookevents),
      );
}

class _EventState extends State<Event> {
  final String eventId;
  final String ownerId;
  final bookevents;
  final String date;
  final String description;
  final String location;
  final String heading;
  final String totalseat;
  int EventCount;
  bool isBooked;
  bool showHeart = false;
  final String currentOnlineUserId = currentUser.id;

  _EventState({
    this.eventId,
    this.ownerId,
    this.bookevents,
    this.date,
    this.description,
    this.location,
    this.heading,
    this.totalseat,
    this.EventCount,
  });

  @override
  Widget build(BuildContext context) {
    isBooked = bookevents[currentOnlineUserId] == true;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Container(
        margin: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            createPostHead(),
            createPostPicture(),
            createPostFooter()
          ],
        ),
      ),
    );
  }

  removeLike() {
    bool isNotPostOwner = currentOnlineUserId != ownerId;

    if (isNotPostOwner) {
      Firestore.instance
          .collection('bookevents')
          .document(ownerId)
          .collection('feedItems')
          .document(eventId)
          .get()
          .then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
    }
  }

  addLike() {
    bool isNotPostOwner = currentOnlineUserId != ownerId;

    if (isNotPostOwner) {
      Firestore.instance
          .collection('bookevents')
          .document(ownerId)
          .collection('feedItems')
          .add({
        'type': 'booked',
        'username': currentUser.username,
        'userId': currentUser.id,
        'timestamp': DateTime.now(),
        'eventId': eventId,
        'ownerId': ownerId,
        'date': date,
        'location': location,
        'totalseat': totalseat,
        'heading': heading,
        'userProfileImg': currentUser.url
      });
    }
  }

  controlUserLikePost() {
    bool _booked = bookevents[currentOnlineUserId] == true;

    if (_booked) {
      Firestore.instance
          .collection('events')
          .document(ownerId)
          .collection("userPosts")
          .document(eventId)
          .updateData({'bookevent.$currentOnlineUserId': false});

      removeLike();

      setState(() {
        EventCount = EventCount - 1;
        isBooked = false;
        bookevents[currentOnlineUserId] = false;
      });
    } else if (!_booked) {
      Firestore.instance
          .collection('events')
          .document(ownerId)
          .collection('userPosts')
          .document(eventId)
          .updateData({'bookevent.$currentOnlineUserId': true});

      addLike();

      setState(() {
        EventCount = EventCount + 1;
        isBooked = true;
        bookevents[currentOnlineUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 800), () {
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  createPostHead() {
    return Container(
      width: 390,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          topLeft: Radius.circular(30),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Center(
            child: Text(
              heading,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 30),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            description,
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 8,
                ),
                Text(
                  location,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(Icons.calendar_today),
                SizedBox(
                  width: 8,
                ),
                Text(
                  date,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Icon(Icons.event_seat),
                SizedBox(
                  width: 8,
                ),
                Text(
                  totalseat,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  createPostPicture() {
    return GestureDetector(
      onTap: () => controlUserLikePost,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: 80,
            width: 190,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
//            child: FlatButton(
//              onPressed: () => controlUserLikePost,
//              padding: EdgeInsets.all(5.0),
//              child: Text(
//                'Book Event',
//                style:
//                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//              ),
//              shape: RoundedRectangleBorder(
//                  side: BorderSide(color: Colors.black, width: 3.0),
//                  borderRadius: BorderRadius.circular(20.0)),
//            ),
          ),
          showHeart
              ? Icon(
                  Icons.offline_pin,
                  size: 80.0,
                  color: Colors.green,
                )
              : GestureDetector(
                  onTap: () => controlUserLikePost(),
                  child: Icon(
                    Icons.offline_pin,
                    size: 80.0,
                    color: isBooked ? Colors.green : Colors.red,
                  ),
                )
        ],
      ),
    );
  }


  createPostFooter() {
    return Container(
      width: 390,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 40.0, left: 20.0),
              ),
              GestureDetector(
                onTap: () => controlUserLikePost(),
                child: Icon(
                  isBooked ? Icons.event_seat : Icons.event_seat,
                  size: 28.0,
                  color: isBooked ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Total Events Book  :  $EventCount',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }
}
