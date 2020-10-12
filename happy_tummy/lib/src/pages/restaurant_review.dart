import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

final DateTime timestamp = DateTime.now();

class SubmitReview extends StatefulWidget {
  final String rId;
  SubmitReview({this.rId});

  @override
  _SubmitReviewState createState() => _SubmitReviewState();
}

class _SubmitReviewState extends State<SubmitReview> {
  double rating = 0.0;
  TextEditingController descriptionEditingController = TextEditingController();
  TextEditingController ratingEditingController = TextEditingController();

  saveReview(){
    print(descriptionEditingController.text);
    print(ratingEditingController.text);
    print(currentUser.id);

    Firestore.instance.collection('restaurantreviews').document(widget.rId).collection("reviews").add({
      'username': currentUser.username,
      'description': descriptionEditingController.text,
      'rating': ratingEditingController.text,
      'timestamp': DateTime.now(),
      'url': currentUser.url,
      'userId': currentUser.id,
      'restaurantId': widget.rId,
    });

    Firestore.instance.collection('bookevents')..document(widget.rId).collection("reviews").add({
      'type':'review',
      'description': descriptionEditingController.text,
      'rating': ratingEditingController.text,
      'restaurantId': widget.rId,
      'userId':currentUser.id,
      'username':currentUser.username,
      'userProfileImg':currentUser.url,
      'timestamp':timestamp,
    });

    descriptionEditingController.clear();
    ratingEditingController.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            'Review',
            style: TextStyle(fontSize: 30, fontFamily: "Lobster"),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.black87,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text(
                  "How was your  ",
                  style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "experience with this place?",
                  style: TextStyle(
                      fontSize: 26.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                SmoothStarRating(
                  starCount: 5,
                  isReadOnly: false,
                  spacing: 5,
                  rating: rating,
                  size: 45,
                  color: Colors.yellow,
                  borderColor: Colors.white,
                  allowHalfRating: true,
                  onRated: (value) {
                    ratingEditingController.text = value.toString();
                    print(ratingEditingController.text);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 120,
                  margin: EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: descriptionEditingController,
                    decoration: InputDecoration(
                      labelText: '              Write your review...',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: "Lobster",
                          fontSize: 25.0),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                GestureDetector(
                  onTap: saveReview,
                  child: Container(
                    height: 60,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                        child: Text(
                      "Send",
                      style:
                          TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
