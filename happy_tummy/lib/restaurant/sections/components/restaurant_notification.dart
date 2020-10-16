
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:timeago/timeago.dart' as tAgo;


class RestaurantNotificationPage extends StatefulWidget {
  final String restaurantid;

  RestaurantNotificationPage({this.restaurantid});
  @override
  _RestaurantNotificationPageState createState() => _RestaurantNotificationPageState();
}

class _RestaurantNotificationPageState extends State<RestaurantNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar (
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        automaticallyImplyLeading: true,
        title: Text("Notification" ,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "PermanentMarker",
            fontSize:32.0,
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
      .orderBy("timestamp", descending: true)
      .limit(60)
      .getDocuments();

  List<NoticationsItem> notificationsItems = [];

  querySnapshot.documents.forEach((document) {
    notificationsItems.add(NoticationsItem.fromDocument(document));
  });

  return notificationsItems;
}
}

String notificationItemText;
Widget mediaPreview;

class NoticationsItem extends StatelessWidget {
  final String username;
  final String type;
  final String eventId;
  final String userId;
  final String userProfileImg;
  final String description;
  final Timestamp timestamp;

  NoticationsItem({
    this.username,
    this.type,
    this.userId,
    this.eventId,
    this.description,
    this.userProfileImg,
    this.timestamp,
  });

  factory NoticationsItem.fromDocument(DocumentSnapshot documentSnapshot) {
    return NoticationsItem(
      username: documentSnapshot['username'],
      type: documentSnapshot['type'],
      description: documentSnapshot['description'],
      eventId: documentSnapshot['postId'],
      userId: documentSnapshot['userId'],
      userProfileImg: documentSnapshot['userProfileImg'],
      timestamp: documentSnapshot['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0, top: 5, left: 10, right: 10),
      child: Container(
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
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ListTile(
          title: RichText(
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: TextStyle(fontSize: 14.0, color: Colors.black),
              children: [
                TextSpan(
                    text: '$username',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontFamily: "Lobster")),
                TextSpan(
                    text: " $notificationItemText",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontFamily: "Lobster")),
              ],
            ),
          ),
          leading: mediaPreview,
          subtitle: Text(
            tAgo.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  configureMediaPreview(context) {
    if (type == "review" || type == "booked") {
      mediaPreview = Container(
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
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == "booked") {
      notificationItemText = "Booked event.";
    } else if (type == "review") {
      notificationItemText = "reviewed : $description";
    } else {
      notificationItemText = "Error,Unknown type = $type .";
    }
  }

}