import 'package:flutter/material.dart';
import 'dart:io';
import 'package:panorama/panorama.dart';
//import 'package:image_picker/image_picker.dart';

class PanoramaPage extends StatefulWidget {
  @override
  _PanoramaPageState createState() => _PanoramaPageState();
}

class _PanoramaPageState extends State<PanoramaPage> {
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Restaurant'),
      ),
      body: Panorama(
        animSpeed: 2.0,
        child: _imageFile != null
            ? Image.file(_imageFile)
            : Image.asset('assets/images/photo360.jpeg'),
      ),
//      floatingActionButton: FloatingActionButton(
//        mini: true,
//        onPressed: () async {
//          _imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
//          setState(() {});
//        },
//        child: Icon(Icons.panorama),
//      ),
    );
  }
}
