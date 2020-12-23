import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/foodorder/foodItem_Card.dart';
import 'package:happy_tummy/restaurant/foodorder/foodshiftorder.dart';
import 'package:happy_tummy/restaurant/models/food_model.dart';
import 'package:happy_tummy/restaurant/ui/widget/tabs.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as InD;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class UploadFoodItemPage extends StatefulWidget {
  final String restaurantProfileId;

  UploadFoodItemPage({this.restaurantProfileId});
  @override
  _UploadFoodItemPageState createState() => _UploadFoodItemPageState();
}

class _UploadFoodItemPageState extends State<UploadFoodItemPage> {
  File _imageFile;
  bool loading = false;
  int countPost = 0;
  List<FoodItem> postsList = [];

  displayProfilePost() {
    if (loading) {
      return circularProgress();
    } else if (postsList.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:30.0),
              child: Icon(
                Icons.photo_library,
                color: Colors.grey,
                size: 150.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'No Food Items',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Lobster"),
              ),
            )
          ],
        ),
      );
    } else {
      List<GridTile> gridTilesList = [];
      postsList.forEach((eachPost) {
        gridTilesList.add(GridTile(child: MenuTile(eachPost)));
      });
      return GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 3.5,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 0.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: gridTilesList,
      );
    }
  }

  getAllProfilePost() async {
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("restarurantMenu")
        .document(widget.restaurantProfileId)
        .collection("restaurantFoodItems")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postsList = querySnapshot.documents
          .map((documentSnapshot) => FoodItem.fromDocument(documentSnapshot))
          .toList();
    });
  }

  @override
  void initState() {
    getAllProfilePost();
    super.initState();
  }

  getTasks(String userId) async {
    return await Firestore.instance
        .collection("restarurantMenu")
        .document(userId)
        .collection("restaurantFoodItems")
        .snapshots();
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(child: Text("Add New FoodItem")),
        actions: [
          FlatButton(
              onPressed: (){
                Route route = MaterialPageRoute(builder: (c) => FoodShiftOrders());
                Navigator.pushReplacement(context, route);
              },
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              )),
        ],
      ),
      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        color: Colors.white54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[
            Container(height: 200,width: 200, child: Image.file(_imageFile),color: Colors.white,),
            Row(
              children: <Widget>[
                Text(
                  "Reset",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),
            Uploader(file: _imageFile, rid: widget.restaurantProfileId)
          ] else ...[
            displayProfilePost(),
          ]
        ],
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  File file;
  final String rid;
  Uploader({this.file, this.rid});
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://happy-tummy-app-472d1.appspot.com');

  String postId = Uuid().v4();
  TextEditingController descriptionTextEditingController =
      TextEditingController();
  TextEditingController categoriesTextEditingController =
      TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController priceTextEditingController = TextEditingController();

  void _startUpload() async {
    await compressingPhoto();

    String downloadUrl = await uploadPhoto(widget.file);

    savePostInfoToFireStore(url: downloadUrl,name: nameTextEditingController.text, description: descriptionTextEditingController.text,category: categoriesTextEditingController.text,price: priceTextEditingController.text);

    nameTextEditingController.clear();
    descriptionTextEditingController.clear();
    categoriesTextEditingController.clear();
    priceTextEditingController.clear();

    setState(() {
      postId = Uuid().v4();
      //_uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    InD.Image mImageFile = InD.decodeImage(widget.file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(InD.encodeJpg(mImageFile, quality: 60));
    setState(() {
      widget.file = compressedImageFile;
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mStorageUploadTask =
        menustorageReference.child('post_$postId.jpg').putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  savePostInfoToFireStore({String url, String name, String description,String category,String price}) {
    menuReference
        .document(widget.rid)
        .collection('restaurantFoodItems')
        .document(postId)
        .setData({
      'postId': postId,
      'ownerId': widget.rid,
      'timestamp': DateTime.now(),
      'url': url,
      'name':name,
      'description':description,
      'category':category,
      'price':price,
    });
  }

  @override
  Widget build(BuildContext context) {
    // Allows user to decide when to start the upload
    return Column(
      children: [
        ListTile(
          leading: Icon(
            Icons.category,
            color: Colors.black,
            size: 30.0,
          ),
          title: Container(
            width: 250.0,
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: categoriesTextEditingController,
              decoration: InputDecoration(
                hintText: "Category",
                hintStyle: TextStyle(
                    color: Colors.black38,
                    fontFamily: "Lobster",
                    fontSize: 20.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Divider(
          indent: 20.0,
          endIndent: 20.0,
        ),
        ListTile(
          leading: Icon(
            Icons.food_bank,
            color: Colors.black,
            size: 30.0,
          ),
          title: Container(
            width: 250.0,
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: nameTextEditingController,
              decoration: InputDecoration(
                hintText: "Name",
                hintStyle: TextStyle(
                    color: Colors.black38,
                    fontFamily: "Lobster",
                    fontSize: 20.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Divider(
          indent: 20.0,
          endIndent: 20.0,
        ),
        ListTile(
          leading: Icon(
            Icons.description,
            color: Colors.black,
            size: 30.0,
          ),
          title: Container(
            width: 250.0,
            child: TextField(
              style: TextStyle(color: Colors.black),
              controller: descriptionTextEditingController,
              decoration: InputDecoration(
                hintText: "Description",
                hintStyle: TextStyle(
                    color: Colors.black38,
                    fontFamily: "Lobster",
                    fontSize: 20.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Divider(
          indent: 20.0,
          endIndent: 20.0,
        ),
        ListTile(
          leading: Icon(
            Icons.monetization_on,
            color: Colors.black,
            size: 30.0,
          ),
          title: Container(
            width: 250.0,
            child: TextField(
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.black),
              controller: priceTextEditingController,
              decoration: InputDecoration(
                hintText: "Price",
                hintStyle: TextStyle(
                    color: Colors.black38,
                    fontFamily: "Lobster",
                    fontSize: 20.0),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Container(
          child: FlatButton.icon(
            label: Text('Upload ',style:TextStyle(fontSize: 20),),
            icon: Icon(Icons.cloud_upload),
            onPressed: () {
              _startUpload();
              final snackBar = SnackBar(
                backgroundColor: Colors.blue,
                content: Text(
                  'Upload Successfull !',
                  style: TextStyle(color: Colors.white),
                ),
                action: SnackBarAction(
                  label: 'Ok',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
        ),
      ],
    );
  }
}
