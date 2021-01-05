import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/foodorder/foodshiftorder.dart';
import 'package:happy_tummy/restaurant/models/food_model.dart';
import 'package:happy_tummy/restaurant/ui/widget/tabs.dart';
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
  Stream taskStream;

  deleteTask(String restaurantId, String postId) {
    Firestore.instance
        .collection("restarurantMenu")
        .document(restaurantId)
        .collection("restaurantFoodItems")
        .document(postId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }

  Widget retrieveFoodItems() {
    return StreamBuilder(
      stream: taskStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.only(top: 3),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        margin: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.teal[50],
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20),
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            )),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
                              width: MediaQuery.of(context).size.width / 3.2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image(
                                  image: NetworkImage(
                                    snapshot.data.documents[index].data["url"],
                                  ),
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height / 7,
                                  width: MediaQuery.of(context).size.height / 5,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 20, 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                        snapshot
                                            .data.documents[index].data["name"],
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          fontFamily: 'PermantMarker',
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1.0,
                                        )),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                        snapshot.data.documents[index]
                                            .data["category"],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'PermantMarker',
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 0.5,
                                            color: Colors.blue)),
                                    SizedBox(height: 10),
                                    RichText(
                                        text: TextSpan(children: [
                                      TextSpan(
                                        text: 'Rs.',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Color(0xFFF4D479),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: snapshot
                                            .data.documents[index].data["price"]
                                            .toString(),
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFFF4D479),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ])),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width / 8,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      deleteTask(
                                          snapshot.data.documents[index]
                                              .data["ownerId"],
                                          snapshot.data.documents[index]
                                              .data["postId"]);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                })
            : Text(
                'suyog',
                style: TextStyle(fontSize: 50),
              );
      },
    );
  }

  @override
  void initState() {
    getTasks(widget.restaurantProfileId).then((val) {
      taskStream = val;
      setState(() {});
    });

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
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (c) => FoodShiftOrders(restaurantProfileId: widget.restaurantProfileId,));
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
        scrollDirection: Axis.vertical,
        children: <Widget>[
          if (_imageFile != null) ...[
            Container(
              height: 200,
              width: 200,
              child: Image.file(_imageFile),
              color: Colors.white,
            ),
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
            Container(child: retrieveFoodItems(),height: MediaQuery.of(context).size.height,)
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
  var selectedCurrency, selectedType;
  List<String> _accountType = <String>[
    'momo',
    'chowmein',
    'thukpa',
    'chopsuey',
    'pasta',
    'beverges',
    'desserts',
    'non-veg',
    'vegeterian',
    'specialities',
    'others',
    'pizza',
    'burgers'
  ];

  void _startUpload(String cate) async {
    await compressingPhoto();

    String downloadUrl = await uploadPhoto(widget.file);

    savePostInfoToFireStore(
        url: downloadUrl,
        name: nameTextEditingController.text,
        description: descriptionTextEditingController.text,
        category: cate,
        price: int.parse(priceTextEditingController.text));

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

  savePostInfoToFireStore(
      {String url,
      String name,
      String description,
      String category,
      int price}) {
    menuReference
        .document(widget.rid)
        .collection('restaurantFoodItems')
        .document(postId)
        .setData({
      'postId': postId,
      'ownerId': widget.rid,
      'timestamp': DateTime.now(),
      'url': url,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
    });
  }

  @override
  Widget build(BuildContext context) {
    // Allows user to decide when to start the upload
    return Column(
      children: [
//        ListTile(
//          leading: Icon(
//            Icons.category,
//            color: Colors.black,
//            size: 30.0,
//          ),
//          title: Container(
//            width: 250.0,
//            child: TextField(
//              style: TextStyle(color: Colors.black),
//              controller: categoriesTextEditingController,
//              decoration: InputDecoration(
//                hintText: "Category",
//                hintStyle: TextStyle(
//                    color: Colors.black38,
//                    fontFamily: "Lobster",
//                    fontSize: 20.0),
//                border: InputBorder.none,
//              ),
//            ),
//          ),
//        ),
        Divider(
          indent: 20.0,
          endIndent: 20.0,
        ),
        DropdownButton(
          items: _accountType
              .map((value) => DropdownMenuItem(
                    child: Text(
                      value,
                      style: TextStyle(color: Colors.black),
                    ),
                    value: value,
                  ))
              .toList(),
          onChanged: (selectedAccountType) {
            print('$selectedAccountType');
            setState(() {
              selectedType = selectedAccountType;
            });
          },
          value: selectedType,
          isExpanded: false,
          hint: Text(
            'Choose Category Type',
            style: TextStyle(color: Colors.black),
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
            label: Text(
              'Upload ',
              style: TextStyle(fontSize: 20),
            ),
            icon: Icon(Icons.cloud_upload),
            onPressed: () {
              print(selectedType);
              _startUpload(selectedType);
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
