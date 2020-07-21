import 'package:flutter/material.dart';
import '../widgets/restaurant.dart';
import '../widgets/food_category.dart';
import '../widgets/home_top_info.dart';
import '../widgets/search_field.dart';
import '../data/restaurant_data.dart';
import '../models/restaurant_model.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
//          Column(
//            children: _restaurants.map(_buildRestaurantItems).toList(),
//          ),
          Container(
            height: 210.0,
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


