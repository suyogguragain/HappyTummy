import 'package:flutter/material.dart';

class FeaturedRestaurant extends StatefulWidget {
  final String id;
  final String name;
  final String imagePath;
  final double ratings;

  FeaturedRestaurant ({this.id,this.name,this.imagePath,this.ratings });

  @override
  _FeaturedRestaurantState createState() => _FeaturedRestaurantState();
}

class _FeaturedRestaurantState extends State<FeaturedRestaurant> {

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: 200.0,
            width: 340.0,
            child: Image.asset(widget.imagePath, fit: BoxFit.cover,),
          ),
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: Container(
              height: 60.0,
              width: 340.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black, Colors.black12
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter
                ),
              ),
            ),
          ),
          Positioned(
            left: 10.0,
            bottom: 10.0,
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.star, color: Theme.of(context).primaryColor,size: 16.0,),
                        Icon(Icons.star, color: Theme.of(context).primaryColor,size: 16.0,),
                        Icon(Icons.star, color: Theme.of(context).primaryColor,size: 16.0,),
                        Icon(Icons.star, color: Theme.of(context).primaryColor,size: 16.0,),
                        SizedBox(width: 20.0,),
                        Text(
                          '('+ widget.ratings.toString() +'22 Reviews)',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
