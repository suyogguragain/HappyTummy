import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:happy_tummy/src/data/cusinecategory_data.dart';
import 'package:happy_tummy/src/models/cusine_model.dart';
import 'package:happy_tummy/src/pages/restauarant_map.dart';
import 'package:happy_tummy/src/pages/restaurant_details.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:happy_tummy/src/widgets/cusine_category.dart';
import '../widgets/restaurant.dart';
import '../widgets/food_category.dart';
import '../widgets/home_top_info.dart';
import '../widgets/search_field.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<CusineCategory> _cusine = cusine_categories;
  TextEditingController locationTextEditingController = TextEditingController();
  Future _data;

  Future getrestaurants() async {
    var firestore = Firestore.instance;

    QuerySnapshot qn = await firestore.collection('restaurants').getDocuments();

    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot restaurant) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RestaurantDetails(
          restaurant: restaurant,
        ),
      ),
    );
  }

  getUserCurrentLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    String completeAddressInfo =
        '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare},${mPlaceMark.subLocality} ${mPlaceMark.locality},${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea},${mPlaceMark.postalCode} ${mPlaceMark.country}';
    String SpecificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
    locationTextEditingController.text = SpecificAddress;
  }

  @override
  void initState() {
    // widget.restaurantModel.fetchRestaurants();
    super.initState();

    _data = getrestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Container(
          width: 250.0,
          child: TextField(
            style: TextStyle(
                color: Colors.white, fontFamily: "Lobster", fontSize: 20.0),
            controller: locationTextEditingController,
            decoration: InputDecoration(
              hintText: "Happy Tummy",
              hintStyle: TextStyle(
                  color: Colors.white, fontFamily: "Lobster", fontSize: 20.0),
              border: InputBorder.none,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: getUserCurrentLocation,
          child: Icon(Icons.location_on),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        children: <Widget>[
          HomeTopInfo(),
          FoodCategory(),
          SizedBox(
            height: 20.0,
          ),
          SearchField(),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Featured restaurants',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RestaurantMap(),
                    ),
                  );
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),

          //fetch restaurant form firestore
          SizedBox(
            height: 210,
            child: FutureBuilder(
                future: _data,
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (!snapshot.hasData) {
                      return circularProgress();
                    }
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index) {
                          return Container(
                            width: 280,
                            margin: EdgeInsets.only(right: 20.0),
                            child: GestureDetector(
                              onTap: () =>
                                  navigateToDetail(snapshot.data[index]),
                              child: FeaturedRestaurant(
                                  id: snapshot.data[index].data['rid'],
                                  name: snapshot.data[index].data['name'],
                                  imagePath: snapshot.data[index].data['photo'],
                                  location:
                                      snapshot.data[index].data['location']),
                            ),
                          );
                        });
                  }
                }),
          ),

          SizedBox(
            height: 20.0,
          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: <Widget>[
//              Text(
//                'Nearby restaurants',
//                style: TextStyle(
//                  fontSize: 18.0,
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//
//            ],
//          ),
//          SizedBox(
//            height: 20.0,
//          ),
//          Container(height: 210, child: Text("nearby")),
//          SizedBox(
//            height: 40.0,
//          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Discover Cuisines',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _cusine.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(right: 20.0),
                  child: Cusine_Category(
                    categoryName: _cusine[index].categoryName,
                    imagePath: _cusine[index].imagePath,
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
