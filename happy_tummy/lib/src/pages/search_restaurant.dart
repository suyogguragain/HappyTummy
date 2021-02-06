import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/short_restaurantprofile.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class SearchRestaurant extends StatefulWidget {
  @override
  _SearchRestaurantState createState() => new _SearchRestaurantState();
}

class _SearchRestaurantState extends State<SearchRestaurant> {
  Future<QuerySnapshot> futureSearchResults;

  controlSearching(String str) {
    Future<QuerySnapshot> allUser = Firestore.instance
        .collection('restaurants')
        .where('name', isGreaterThanOrEqualTo: str)
        .getDocuments();
    setState(() {
      futureSearchResults = allUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text(
            'Restaurant search',
            style: TextStyle(fontFamily: "Roboto", fontSize: 30),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: ListView(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(Icons.arrow_back),
                  iconSize: 20.0,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                contentPadding: EdgeInsets.only(left: 25.0),
                hintText: 'Search by name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0)),
              ),
              onFieldSubmitted: controlSearching,
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
                Route route = MaterialPageRoute(
                    builder: (c) => FilterRestaurantProfile(
                      restaurantProfileId: eachUser.rid,
                    ));
                Navigator.pushReplacement(context, route);
                //displayUserProfile(context, userprofileId: eachUser.id);
              },
              child: ListTile(
                leading: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(eachUser.photo), fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                title: Text(
                  eachUser.name,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20.0,
                    fontFamily: 'Lobster',
                  ),
                ),
                subtitle: Text(
                  eachUser.location,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 13.0,
                  ),
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

  Restaurant({
    this.rid,
    this.name,
    this.location,
    this.photo,
  });

  factory Restaurant.fromDocument(DocumentSnapshot doc) {
    return Restaurant(
      rid: doc.documentID,
      name: doc['name'],
      location: doc['location'],
      photo: doc['photo'],
    );
  }
}
