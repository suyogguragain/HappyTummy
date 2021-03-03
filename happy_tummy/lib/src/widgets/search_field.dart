import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/search_restaurant.dart';

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      child: GestureDetector(
        onTap: () {
          print('tap');
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchRestaurant(),
              ));
        },
        child: Container(
          width: 250,
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  'Search Restaurants',
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
        ),
      ),
    );
  }
}
