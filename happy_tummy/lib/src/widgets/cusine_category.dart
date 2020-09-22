import 'package:flutter/material.dart';


class Cusine_Category extends StatefulWidget{
  final String categoryName;
  final String imagePath;

  Cusine_Category({this.categoryName, this.imagePath});

  @override
  _Cusine_CategoryState createState() => _Cusine_CategoryState();
}

class _Cusine_CategoryState extends State<Cusine_Category> {
  @override
  Widget build(BuildContext context){
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: 100.0,
            width: 200.0,
            child: Image.asset(widget.imagePath, fit: BoxFit.cover,),
          ),
          Positioned(
            left: 60.0,
            bottom: 30.0,
            child: Row(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.categoryName,
                      style: TextStyle(
                        fontSize: 28.0,
                        fontFamily: "Lobster",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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