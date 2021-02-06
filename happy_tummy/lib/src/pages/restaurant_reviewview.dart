import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happytummy_sentiment/happytummy_sentiment.dart';
import 'package:timeago/timeago.dart' as tAgo;

class Review extends StatelessWidget {
  final String username;
  final String userId;
  final String url;
  final String description;
  final String rating;
  //final double rating;
  final Timestamp timestamp;
  final String restaurantId;

  Review(
      {this.username,
      this.userId,
      this.url,
      this.rating,
      this.description,
      this.timestamp,
      this.restaurantId});

  factory Review.fromDocument(DocumentSnapshot documentSnapshot) {
    return Review(
      username: documentSnapshot['username'],
      userId: documentSnapshot['userId'],
      url: documentSnapshot['url'],
      description: documentSnapshot['description'],
      rating: documentSnapshot['rating'].toString(),
      timestamp: documentSnapshot['timestamp'],
      restaurantId: documentSnapshot['restaurantId'],
    );
  }

  final sentiment = Sentiment();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0, top: 10),
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 1,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  height: 60,
                  width: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(url),
                        fit: BoxFit.cover,
                      )),
                ),
                Container(
                  height: 60,
                  width: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          username,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black54,
                              fontFamily: "Lobster"),
                        ),
                      ),
                      Container(
                        child: Text(
                          tAgo.format(timestamp.toDate()),
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  height: 60,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        ((double.parse(rating) + (sentiment.analysis1(description,emoji:true)))/ 2).toString(),
                        style: TextStyle(color: Colors.black),
                      ),
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 15,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              child: Text(
                description,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            Text('${(sentiment.analysis(description,emoji:true))}'),
          ],
        ),
      ),
    );
  }
}
