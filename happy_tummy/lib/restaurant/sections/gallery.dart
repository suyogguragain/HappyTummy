import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/restaurant/models/gallery_model.dart';
import 'file:///D:/ProgramFiles/Flutter_projects/HappyTummy/happy_tummy/lib/restaurant/sections/components/gallery_tile.dart';
import 'package:happy_tummy/restaurant/ui/widget/tabs.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as InD;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';


class GalleryPage extends StatefulWidget {
  final String restaurantProfileId;

  GalleryPage({this.restaurantProfileId});
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  File _imageFile;
  bool loading = false;
  int countPost = 0;
  List <Gallery> postsList = [];



  displayProfilePost(){
    if(loading){
      return circularProgress();
    }
    else if(postsList.isEmpty){
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Icon(Icons.photo_library,color: Colors.grey,size: 200.0,),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text('No Posts',style: TextStyle(color: Colors.redAccent,fontSize: 40.0,fontWeight: FontWeight.bold,fontFamily: "Lobster"),),
            )
          ],
        ),
      );
    }
    else {
      List<GridTile> gridTilesList = [];
      postsList.forEach((eachPost) {
        gridTilesList.add(GridTile(child: GalleryTile(eachPost)));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.1,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 0.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children:  gridTilesList,
      );
    }
  }

  getAllProfilePost() async {
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await gallerysReference.document(widget.restaurantProfileId).collection("restaurantGallery").orderBy("timestamp",descending: true).getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postsList = querySnapshot.documents.map((documentSnapshot) => Gallery.fromDocument(documentSnapshot)).toList();
    });
  }




  @override
  void initState() {
    getAllProfilePost();
    super.initState();
  }

  getTasks(String userId) async {
    return await gallerysReference
        .document(userId)
        .collection("restaurantGallery")
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
      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        color: Colors.orange.shade200,
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
            Container(height: 410,child: Image.file(_imageFile)),
            Row(
              children: <Widget>[
                Text(
                  "Reset",
                  style: TextStyle(
                    fontSize: 20,
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

  StorageUploadTask _uploadTask;
  String postId = Uuid().v4();

  /// Starts an upload task
//  void _startUpload() {
//
//    /// Unique file name for the file
//    String filePath = 'gallery/${DateTime.now()}.png';
//
//    setState(() {
//      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
//    });
//  }

  void _startUpload() async {
    await compressingPhoto();

    String downloadUrl = await uploadPhoto(widget.file);

    savePostInfoToFireStore(url: downloadUrl);

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
        gallerystorageReference.child('post_$postId.jpg').putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot =
        await mStorageUploadTask.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  savePostInfoToFireStore({String url, String location, String description}) {
    gallerysReference
        .document(widget.rid)
        .collection('restaurantGallery')
        .document(postId)
        .setData({
      'postId': postId,
      'ownerId': widget.rid,
      'timestamp': DateTime.now(),
      'url': url,
    });
  }

  @override
  Widget build(BuildContext context) {
//    if (_uploadTask != null) {
//
//      /// Manage the task state and event subscription with a StreamBuilder
//      return StreamBuilder<StorageTaskEvent>(
//          stream: _uploadTask.events,
//          builder: (_, snapshot) {
//            var event = snapshot?.data?.snapshot;
//
//            double progressPercent = event != null
//                ? event.bytesTransferred / event.totalByteCount
//                : 0;
//
//            return Column(
//
//              children: [
//                if (_uploadTask.isComplete)
//                  Text('🎉🎉🎉'),
//
//
//                if (_uploadTask.isPaused)
//                  FlatButton(
//                    child: Icon(Icons.play_arrow),
//                    onPressed: _uploadTask.resume,
//                  ),
//
//                if (_uploadTask.isInProgress)
//                  FlatButton(
//                    child: Icon(Icons.pause),
//                    onPressed: _uploadTask.pause,
//                  ),
//
//                // Progress bar
//                LinearProgressIndicator(value: progressPercent),
//                Text(
//                    '${(progressPercent * 100).toStringAsFixed(2)} % '
//                ),
//              ],
//            );
//          });
//
//
//    } else {

    // Allows user to decide when to start the upload
    return FlatButton.icon(
      label: Text('Upload '),
      icon: Icon(Icons.cloud_upload),
      onPressed: (){
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

    );

//    }
  }
}
