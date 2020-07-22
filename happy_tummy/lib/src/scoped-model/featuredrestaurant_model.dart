import 'dart:convert';

import 'package:happy_tummy/src/models/restaurant_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class FeaturedRestaurantModel extends Model {
  List<Restaurant_Featured> _restaurants = [];

  List<Restaurant_Featured> get restaurants {
    return List.from(_restaurants);
  }
  
  void addrestaurant(Restaurant_Featured restaurant){
    _restaurants.add(restaurant);
  }
  
  void fetchRestaurants() {
    http.get("http://192.168.100.2:8080/happy_tummy_app/api/restaurant/getfeaturedrestaurant.php")
        .then((http.Response response){
          final List fetchedData = json.decode(response.body);
          final List<Restaurant_Featured> fetchedRestaurantLists = [];

          fetchedData.forEach((data) {
            Restaurant_Featured restaurant = Restaurant_Featured(
              id: data['id'],
              ratings: double.parse(data['rating']),
              imagePath: data['image_path'],
              name: data['name']
            );
            fetchedRestaurantLists.add(restaurant);
          });
          _restaurants = fetchedRestaurantLists;
          print(_restaurants);
    });
  }

}