import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as InD;

class UploadPage extends StatefulWidget {
  final User gCurrentUser;

  UploadPage({this.gCurrentUser});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>  with AutomaticKeepAliveClientMixin<UploadPage> {
  File file;
  bool uploading = false;
  String postId = Uuid().v4();
  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  captureImageWithCamera() async {
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source:ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  pickImageFromGallery() async{
    Navigator.pop(context);
    File imageFile = await ImagePicker.pickImage(
      source:ImageSource.gallery,
    );
    setState(() {
      this.file = imageFile;
    });
  }

  takeImage(mContext){
    return showDialog(
      context: mContext,
      builder: (context){
        return SimpleDialog(
          title: Text('New Post',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 30.0,
          ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              child: Text('Capture image with camera',style: TextStyle(
                color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20.0,fontFamily: "Roboto",),
              ),
              onPressed: captureImageWithCamera,
            ),
            SimpleDialogOption(
              child: Text('Select image from gallery',style: TextStyle(
                color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20.0,fontFamily: "Roboto",),
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text('Cancel',style: TextStyle(
                color: Colors.black,fontWeight: FontWeight.normal,fontSize: 20.0,fontFamily: "Roboto",),
              ),
              onPressed:() => Navigator.pop(context),
            ),
          ],
        );
      }
    );
  }

  displayUploadScreen(){
    return Container(
      color: Colors.black12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.add_a_photo,color: Colors.grey,size: 100.0,),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.0),),
                child: Text("Upload Post",style:TextStyle(color:Colors.white,fontSize: 20.0,fontFamily: "Lobster"),),
                color: Colors.black,
                onPressed: () => takeImage(context)
            ),
          )
        ],
      ),
    );
  }

  ClearPostInfo() {
    locationTextEditingController.clear();
    descriptionTextEditingController.clear();

    setState(() {
      file = null;
    });
  }
  getUserCurrentLocation () async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare},${mPlaceMark.subLocality} ${mPlaceMark.locality},${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea},${mPlaceMark.postalCode} ${mPlaceMark.country}';
    String SpecificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
    locationTextEditingController.text = SpecificAddress;
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    InD.Image mImageFile = InD.decodeImage(file.readAsBytesSync());
    final compressedImageFile = File ('$path/img_$postId.jpg')..writeAsBytesSync(InD.encodeJpg(mImageFile,quality: 60));
    setState(() {
      file = compressedImageFile;
    });
  }

  savePostInfoToFireStore({String url, String location,String description}) {
    postsReference.document(widget.gCurrentUser.id).collection('userPosts').document(postId).setData({
      'postId':postId,
      'ownerId' : widget.gCurrentUser.id,
      'timestamp':DateTime.now(),
      'username':widget.gCurrentUser.username,
      'description':description,
      'location':location,
      'url':url,
      'likes':{},
    });
  }

  Future<String> uploadPhoto(mImageFile) async {
    StorageUploadTask mStorageUploadTask = storageReference.child(
        'post_$postId.jpg').putFile(mImageFile);
    StorageTaskSnapshot storageTaskSnapshot = await mStorageUploadTask
        .onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  controlUploadAndSave() async {
    setState(() {
      uploading = true;
    });
    await compressingPhoto();

    String downloadUrl = await uploadPhoto(file);

    savePostInfoToFireStore(url: downloadUrl, location:locationTextEditingController.text, description:descriptionTextEditingController.text);

    locationTextEditingController.clear();
    descriptionTextEditingController.clear();
    setState(() {
      file = null;
      uploading = false;
      postId = Uuid().v4();
    });
  }

  displayUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios, color: Colors.white,), onPressed: ClearPostInfo),
        title: Text('New Post', style: TextStyle(fontSize: 24.0, color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'PermanentMarker'),),
        actions: <Widget>[
          FlatButton(
              onPressed: uploading ? null : () => controlUploadAndSave(),
              child: Text('Post', style: TextStyle(fontSize: 32.0, color: Colors.white, fontWeight: FontWeight.bold,fontFamily: 'EastSeaDokdo')),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          uploading ? LinearProgress() : Text(''),
          Container(
            height: 220.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration: BoxDecoration(image: DecorationImage(image: FileImage(file), fit: BoxFit.cover)),
                  ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(widget.gCurrentUser.url),),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(color: Colors.black38,fontFamily: "Lobster",fontSize: 20.0),
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
            leading: Icon(Icons.location_on,color: Colors.black, size: 26.0,),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(color: Colors.black),
                controller: locationTextEditingController,
                decoration: InputDecoration(
                  hintText: "Location",
                  hintStyle: TextStyle(color: Colors.black38,fontFamily: "Lobster",fontSize: 20.0),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 220.0,
            height: 110.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0)),
              color: Colors.black54,
              icon: Icon(Icons.location_on,color: Colors.white,),
              label: Text('Get Current Location',
                style: TextStyle(color: Colors.white,fontFamily: "Lobster",fontSize: 20.0),
              ),
              onPressed: getUserCurrentLocation,
            ),
          ),
        ],
      ),
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return file == null ? displayUploadScreen() : displayUploadFormScreen();
  }
}
