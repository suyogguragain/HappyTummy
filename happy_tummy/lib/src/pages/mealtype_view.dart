import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/restaurant_details.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:happy_tummy/src/widgets/restaurant.dart';

class MealTypeView extends StatefulWidget {
  final String mealtype;
  MealTypeView({this.mealtype});
  @override
  _MealTypeViewState createState() => new _MealTypeViewState();
}

class _MealTypeViewState extends State<MealTypeView> {
  Future<QuerySnapshot> futureSearchResults;

  controlSearching(String str) {
    Future<QuerySnapshot> allUser = Firestore.instance
        .collection('restaurants')
        .where('mealtype', isEqualTo: str)
        .getDocuments();
    setState(() {
      futureSearchResults = allUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          centerTitle: true,
          title: Text(
            'Happy Tummy',
            style: TextStyle(fontSize: 30, fontFamily: "Roboto"),
          ),
          backgroundColor: Colors.black,
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: controlSearching('${widget.mealtype}'),
              child: Center(
                  child: Text(
                "Restaurant filter based on ${widget.mealtype} ",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ),
          ),
          SizedBox(height: 10.0),
          GridView.count(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              crossAxisCount: 1,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 4.0,
              primary: false,
              shrinkWrap: true,
              children: [
                FutureBuilder(
                  future: futureSearchResults,
                  builder: (context, dataSnapshot) {
                    if (!dataSnapshot.hasData) {
                      return circularProgress();
                    }

                    List<UserResult> searchUsersResult = [];
                    dataSnapshot.data.documents.forEach((document) {
                      Restaurant eachUser = Restaurant.fromDocument(document);
                      UserResult userResult = UserResult(eachUser);
                      searchUsersResult.add(userResult);
                    });
                    return ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: searchUsersResult);
                  },
                )
              ])
        ]));
  }
}

class UserResult extends StatelessWidget {
  final Restaurant eachUser;
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
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
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print('${eachUser.rid}');
                //displayUserProfile(context, userprofileId: eachUser.id);
              },
              child: ListTile(
                contentPadding: EdgeInsets.only(
                    top: 2.0, left: 10.0, bottom: 2.0, right: 10),
                title: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(eachUser.photo),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eachUser.name,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lobster',
                          ),
                        ),
                        Text(
                          eachUser.location,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13.0,
                          ),
                        ),
                        Text(
                          eachUser.cusine,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                          ),
                        ),
                        Text(
                          eachUser.mealtype,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                          ),
                        ),
                      ],
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

class Restaurant {
  final String rid;
  final String name;
  final String location;
  final String photo;
  final String cusine;
  final String mealtype;

  Restaurant({
    this.rid,
    this.name,
    this.location,
    this.photo,
    this.cusine,
    this.mealtype,
  });

  factory Restaurant.fromDocument(DocumentSnapshot doc) {
    return Restaurant(
      rid: doc.documentID,
      name: doc['name'],
      location: doc['location'],
      photo: doc['photo'],
      cusine: doc['cusines'],
      mealtype: doc['mealtype'],
    );
  }
}
