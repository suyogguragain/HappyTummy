import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'file:///D:/ProgramFiles/Flutter_projects/HappyTummy/happy_tummy/lib/restaurant/sections/components/gallery_model.dart';
import 'package:happy_tummy/restaurant/ui/widget/tabs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as InD;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class Gallery extends StatefulWidget {
  final String restaurantProfileId;

  Gallery({this.restaurantProfileId});
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  File _imageFile;

  Stream taskStream;

  Widget taskList() {
    return StreamBuilder(
      stream: taskStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.only(top: 16),
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GalleryCard(
                    snapshot.data.documents[index].data['postId'],
                    snapshot.data.documents[index].data["url"],
                    snapshot.data.documents[index].data["ownerId"],
                  );
                })
            : Container();
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
      body: SizedBox(
        height: 400,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: 300,
            child: ListView(
              scrollDirection: Axis.vertical,
              children: <Widget>[
                if (_imageFile != null) ...[
                  Image.file(_imageFile),
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
                  taskList(),
                ]
              ],
            ),
          ),
        ),
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
      onPressed: _startUpload,
    );

//    }
  }
}
