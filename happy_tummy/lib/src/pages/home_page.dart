import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:happy_tummy/src/data/cusinecategory_data.dart';
import 'package:happy_tummy/src/data/featuredrestaurant_data.dart';
import 'package:happy_tummy/src/models/cusine_model.dart';
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
  List<Featured_Restaurant> _restaurants = featured;
  List<CusineCategory> _cusine = cusine_categories;
  TextEditingController locationTextEditingController = TextEditingController();

  getUserCurrentLocation () async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare},${mPlaceMark.subLocality} ${mPlaceMark.locality},${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea},${mPlaceMark.postalCode} ${mPlaceMark.country}';
    String SpecificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
    locationTextEditingController.text = SpecificAddress;
  }

  @override
  void initState() {
   // widget.restaurantModel.fetchRestaurants();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Container(
          width: 250.0,
          child: TextField(
            style: TextStyle(color: Colors.white,fontFamily: "Lobster",fontSize: 20.0),
            controller: locationTextEditingController,
            decoration: InputDecoration(
              hintText: "Location",
              hintStyle: TextStyle(color: Colors.white,fontFamily: "Lobster",fontSize: 20.0),
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
        padding: EdgeInsets.only(top:20.0, left:20.0, right:20.0),
        children: <Widget>[
          HomeTopInfo(),
          FoodCategory(),
          SizedBox(height: 20.0,),
          SearchField(),
          SizedBox(height: 20.0,),
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
                onTap: (){},
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
          SizedBox(height: 20.0,),
          Container(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _restaurants.length,
                itemBuilder: (BuildContext context, int index){
                    return Container(
                      margin: EdgeInsets.only(right: 20.0),
                      child: FeaturedRestaurant(
                        id: _restaurants[index].id,
                        name: _restaurants[index].name,
                        imagePath: _restaurants[index].imagePath,
                        ratings: _restaurants[index].ratings,
                      ),
                    );
                  },
            ),
          ),
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Nearby restaurants',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: (){},
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
          SizedBox(height: 20.0,),
          Container(
            height: 210,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _restaurants.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  width: 200,
                  margin: EdgeInsets.only(right: 20.0),
                  child: FeaturedRestaurant(
                    id: _restaurants[index].id,
                    name: _restaurants[index].name,
                    imagePath: _restaurants[index].imagePath,
                    ratings: _restaurants[index].ratings,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 40.0,),
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
          SizedBox(height: 20.0,),
          Container(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _cusine.length,
              itemBuilder: (BuildContext context, int index){
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
          SizedBox(height: 20.0,),

//          Column(
//            children: _restaurants.map(_buildRestaurantItems).toList(),
//          ),
//          ScopedModelDescendant<MainModel>(
//            builder: (BuildContext context,Widget child, MainModel model) {
//              return Container(
//                height: 210.0,
//                child: ListView.builder(
//                  scrollDirection: Axis.horizontal,
//                  itemCount: model.restaurants.length,
//                  itemBuilder: (BuildContext context, int index){
//                    return Container(
//                      margin: EdgeInsets.only(right: 20.0),
//                      child: FeaturedRestaurant(
//                        id: model.restaurants[index].id,
//                        name: model.restaurants[index].name,
//                        imagePath: model.restaurants[index].imagePath,
//                        ratings: model.restaurants[index].ratings,
//                      ),
//                    );
//                  },
//                ),
//              );
//            },
//          ),

        ],
      ),
    );
  }
}

//Widget _buildRestaurantItems(Restaurant_Featured Restaurant){
//  return Container(
//    margin: EdgeInsets.only(bottom: 20.0,),
//    child: FeaturedRestaurant(
//      id: Restaurant.id,
//      name: Restaurant.name,
//      imagePath: Restaurant.imagePath,
//      ratings: Restaurant.ratings,
//    ),
//  );
//}



