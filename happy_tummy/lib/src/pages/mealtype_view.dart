import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

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
          title: Text('Happy Tummy'),
          backgroundColor: Colors.deepOrange,
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
              onTap: controlSearching('${widget.mealtype}'),
              child: Text("Restaurant having ${widget.mealtype} "),
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
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                print('${eachUser.rid}');
                //displayUserProfile(context, userprofileId: eachUser.id);
              },
              child: ListTile(
                contentPadding: EdgeInsets.only(top: 4.0, left: 30.0),
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.deepOrange,
                      child: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(eachUser.photo),radius: 40,
                      ),
                    ),
                    SizedBox(width: 20,),
                    Column( mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eachUser.name,
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontSize: 20.0,
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
