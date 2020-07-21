import 'package:flutter/material.dart';
import 'widgets/restaurant.dart';
import 'widgets/food_category.dart';
import 'widgets/home_top_info.dart';
import 'widgets/search_field.dart';
import 'data/restaurant_data.dart';
import 'models/restaurant_model.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Restaurant_Featured> _restaurants = restaurants;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.only(top:45.0, left:20.0, right:20.0),
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
          Column(
            children: _restaurants.map(_buildRestaurantItems).toList(),
            ),
        ],
      ),
    );
  }
}

Widget _buildRestaurantItems(Restaurant_Featured Restaurant){
  return Container(
    margin: EdgeInsets.only(bottom: 20.0,),
    child: FeaturedRestaurant(
      id: Restaurant.id,
      name: Restaurant.name,
      imagePath: Restaurant.imagePath,
      ratings: Restaurant.ratings,
    ),
  );
}


