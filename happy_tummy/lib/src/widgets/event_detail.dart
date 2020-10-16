
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:happy_tummy/src/widgets/event_widget.dart';

class EventDetailPage extends StatelessWidget {
  final String eventId;
  final String userId;

  EventDetailPage({
    this.eventId,
    this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firestore.instance.collection('events').document(userId).collection("userPosts").document(eventId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }

        Event post = Event.fromDocument(dataSnapshot.data);

        return Center(
          child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(title: Text("Event Details"),backgroundColor: Colors.black,),
            body: ListView(
              children: <Widget>[
                Container(
                    child: post,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
