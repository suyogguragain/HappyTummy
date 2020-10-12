
import 'package:flutter/material.dart';

class MenuPhotoPage extends StatefulWidget {
  @override
  _MenuPhotoPageState createState() => _MenuPhotoPageState();
}

class _MenuPhotoPageState extends State<MenuPhotoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text('Menu',style: TextStyle(fontSize: 30,fontFamily: "Lobster"),),
        ),
        body: Container(
          child: Text('Suyog'),
        )
    );
  }
}