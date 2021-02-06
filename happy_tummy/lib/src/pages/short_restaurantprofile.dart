import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/models/gallery_model.dart';
import 'package:happy_tummy/restaurant/ui/widget/tabs.dart';
import 'package:happy_tummy/src/models/restaurantprofile_completemodel.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/menu_photo.dart';
import 'package:happy_tummy/src/pages/panaroma.dart';
import 'package:happy_tummy/src/pages/restaurant_gallerytile.dart';
import 'package:happy_tummy/src/pages/restaurant_review.dart';
import 'package:happy_tummy/src/pages/restaurant_reviewview.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class FilterRestaurantProfile extends StatefulWidget {
  final String restaurantProfileId;

  FilterRestaurantProfile({this.restaurantProfileId});

  @override
  _FilterRestaurantProfileState createState() =>
      _FilterRestaurantProfileState();
}

class _FilterRestaurantProfileState extends State<FilterRestaurantProfile>
    with SingleTickerProviderStateMixin {
  bool loading = false;
  int countPost = 0;
  List<ProfileItem> postsList = [];
  Stream taskStream;
  List<Gallery> galleryList = [];

  TabController _controller;

  displaygallery() {
    if (loading) {
      return circularProgress();
    } else if (galleryList.isEmpty) {
      return Container(
        height: 120,
        width: 200,
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
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Icon(
                Icons.photo_library,
                color: Colors.grey,
                size: 20.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'No Photo',
                style: TextStyle(
                    color: Colors.black54,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Lobster"),
              ),
            )
          ],
        ),
      );
    } else {
      List<GridTile> gridTilesList = [];
      galleryList.forEach((eachPost) {
        gridTilesList.add(GridTile(child: RestaurantGalleryTile(eachPost)));
      });
      return SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: gridTilesList,
        ),
      );
    }
  }

  getRestaurantGallery() async {
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await gallerysReference
        .document(widget.restaurantProfileId)
        .collection("restaurantGallery")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      galleryList = querySnapshot.documents
          .map((documentSnapshot) => Gallery.fromDocument(documentSnapshot))
          .toList();
    });
  }

  getGalleryTasks(String userId) async {
    return await gallerysReference
        .document(userId)
        .collection("restaurantGallery")
        .snapshots();
  }

  createOrientation() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 100,
            width: 100,
            child: Image.asset('assets/images/ht.png'),
          ),
          Text(
            "Happy Tummy",
            style: TextStyle(
                fontFamily: "Lobster",
                fontSize: 21.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
        ],
      ),
    );
  }

  retrieveReviews() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('restaurantreviews')
          .document(widget.restaurantProfileId)
          .collection('reviews')
          .orderBy("timestamp", descending: false)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<Review> reviews = [];
        dataSnapshot.data.documents.forEach((document) {
          reviews.add(Review.fromDocument(document));
        });
        return ListView(
          children: reviews,
        );
      },
    );
  }

  Widget retrieveRestaurantProfile() {
    return StreamBuilder(
      stream: taskStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 260.0,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(snapshot
                                                .data
                                                .documents[index]
                                                .data["photo"]),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.black87,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 20),
                                            child: Text(
                                              snapshot.data.documents[index]
                                                  .data["name"],
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              print('VR');
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PanoramaPage(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 70,
                                              margin:
                                                  EdgeInsets.only(left: 120),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                child: Text(
                                                  'VR',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, top: 10),
                                              child: Icon(
                                                Icons.location_on,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 7),
                                              child: Text(
                                                snapshot.data.documents[index]
                                                    .data["location"],
                                                style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 2,
                                        color: Colors.grey,
                                        thickness: 2,
                                        indent: 20,
                                        endIndent: 20,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 5, top: 5),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, top: 10),
                                              child: Icon(
                                                Icons.phone,
                                                color: Colors.blue,
                                                size: 20,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 7),
                                              child: Text(
                                                snapshot.data.documents[index]
                                                    .data["phone"],
                                                style: TextStyle(
                                                    fontSize: 17.0,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                        height: 2,
                                        color: Colors.grey,
                                        thickness: 2,
                                        indent: 20,
                                        endIndent: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      DefaultTabController(
                                        length: 3,
                                        initialIndex: 0,
                                        child: Container(
                                          child: TabBar(
                                            controller: _controller,
                                            labelColor: Colors.white,
                                            unselectedLabelColor: Colors.white,
                                            indicatorColor: Colors.white,
                                            tabs: [
                                              Tab(
                                                child: Text(
                                                  "About",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                              Tab(
                                                child: Text(
                                                  "Reviews",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                              Tab(
                                                child: Text(
                                                  "Opening Hours",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 380,
                                  child: TabBarView(
                                    controller: _controller,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(30),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Cusines : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["cusines"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Mealtype : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["mealtype"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Outlettype : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["outlettype"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Billing Extra : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["billingextra"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Parking : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["parking"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Payment Method : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["paymentmethod"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                              child: displaygallery(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: retrieveReviews(),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(30),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Monday : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["monday"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Tuesday : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["tuesday"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Wednesday : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["wednesday"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Thursday : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["thrusday"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Friday : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["friday"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Saturday : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["saturday"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Sunday : ",
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  snapshot.data.documents[index]
                                                      .data["sunday"],
                                                  style: TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      createOrientation(),
                      Divider(
                        thickness: 2,
                      ),
                    ],
                  );
                })
            : Text(
                '',
                style: TextStyle(fontSize: 50),
              );
      },
    );
  }

  @override
  void initState() {
    getRestaurantGallery();
    getTasks(widget.restaurantProfileId).then((val) {
      taskStream = val;
      setState(() {});
    });

    super.initState();
    _controller = new TabController(length: 3, vsync: this);
  }

  getTasks(String userId) async {
    return await Firestore.instance
        .collection("restaurants")
        .where('rid', isEqualTo: userId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(child: Text("Restaurant Profile")),
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            child: retrieveRestaurantProfile(),
            height: MediaQuery.of(context).size.height,
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            label: Text('Submit Review'),
            onPressed: () {
              print('review');
              print('${currentUser.id}');
              print('${widget.restaurantProfileId}');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubmitReview(
                    rId: widget.restaurantProfileId,
                  ),
                ),
              );
            },
            heroTag: null,
          ),
          SizedBox(
            width: 60,
          ),
          FloatingActionButton(
            backgroundColor: Colors.black87,
            onPressed: () {
              print('photo menu');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MenuPhotoPage(restaurantid: widget.restaurantProfileId),
                ),
              );
            },
            child: Icon(
              Icons.restaurant_menu,
              color: Colors.white,
              size: 30,
            ),
            heroTag: null,
          ),
        ],
      ),
    );
  }
}
