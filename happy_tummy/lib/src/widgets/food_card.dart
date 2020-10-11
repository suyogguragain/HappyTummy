import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/mealtype_view.dart';

class FoodCard extends StatelessWidget {
  final String categoryName;
  final String imagePath;

  FoodCard({this.categoryName, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 5.0),
      child: GestureDetector(
        onTap: () {
          print(categoryName);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MealTypeView(mealtype: categoryName),
              ));
        },
        child: Card(
          shadowColor: Colors.grey.withOpacity(0.5),
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 6.0),
            child: Row(
              children: <Widget>[
                Image(
                  image: AssetImage(imagePath),
                  height: 38.0,
                  width: 38.0,
                ),
                SizedBox(
                  width: 15.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      categoryName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
