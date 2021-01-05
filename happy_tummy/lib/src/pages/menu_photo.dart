import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/models/menu_model.dart';
import 'package:happy_tummy/restaurant/ui/widget/tabs.dart';
import 'package:happy_tummy/src/pages/restaurant_menutile.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class MenuPhotoPage extends StatefulWidget {
  final String restaurantid;
  MenuPhotoPage({this.restaurantid});

  @override
  _MenuPhotoPageState createState() => _MenuPhotoPageState();
}

class _MenuPhotoPageState extends State<MenuPhotoPage> {
  bool loading = false;
  int countPost = 0;
  List<Menu> menuList = [];

  @override
  void initState() {
    getRestaurantMenu();
    super.initState();
  }

  displaymenu() {
    if (loading) {
      return circularProgress();
    } else if (menuList.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
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
      menuList.forEach((eachPost) {
        gridTilesList.add(GridTile(child: RestaurantMenuTile(eachPost)));
      });
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          scrollDirection: Axis.vertical,
          children: gridTilesList,
        ),
      );
    }
  }

  getRestaurantMenu() async {
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await menuReference
        .document(widget.restaurantid)
        .collection("restaurantMenu")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      menuList = querySnapshot.documents
          .map((documentSnapshot) => Menu.fromDocument(documentSnapshot))
          .toList();
    });
  }

  getTasks(String userId) async {
    return await menuReference
        .document(userId)
        .collection("restaurantMenu")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Text(
          'Menu',
          style: TextStyle(fontSize: 30, fontFamily: "Roboto"),
        ),
      ),
      body: Container(
        child: displaymenu(),
      ),
    );
  }
}
