import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;

  EditProfilePage({this.currentOnlineUserId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameTextEditingController = TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _bioValid = true;
  bool _profileNameValid = true;

  void initState(){
    super.initState();

    getAndDisplayUserInformation();
  }

  getAndDisplayUserInformation() async {
    setState(() {
      loading = true;
    });

    DocumentSnapshot documentSnapshot = await usersReference.document(widget.currentOnlineUserId).get();
    user = User.fromDocument(documentSnapshot);

    profileNameTextEditingController.text = user.profileName;
    bioTextEditingController.text = user.bio;

    setState(() {
      loading = false;
    });
  }

  updateUserData(){
    setState(() {
      profileNameTextEditingController.text.trim().length < 3 || profileNameTextEditingController.text.isEmpty ? _profileNameValid = false : _profileNameValid= true ;

      bioTextEditingController.text.trim().length > 110 ? _bioValid = false : _bioValid = true;
    });

    if(_bioValid && _profileNameValid){
      usersReference.document(widget.currentOnlineUserId).updateData({
        'profileName':profileNameTextEditingController.text,
        'bio': bioTextEditingController.text,
      });

      SnackBar successSnackBar = SnackBar(content: Text('Your Profile has been updated sucessfully.'));
      _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Edit Profile',style: TextStyle(color: Colors.white,fontFamily: "PermanentMarker",fontSize: 28.0),),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.done, color: Colors.white, size: 30.0),
          onPressed: () => Navigator.pop(context),
          ),
          ],
      ),
          body: loading ? circularProgress() :ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 15.0,bottom: 7.0),
                      child: CircleAvatar(
                        radius: 69.0,
                        backgroundImage: CachedNetworkImageProvider(user.url),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: <Widget>[ createProfileNameTextFormField(), createBioTextFormField()],),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 29.0,left: 50.0,right: 50.0),
                      child: RaisedButton(
                        color: Colors.black45,
                        onPressed: updateUserData,
                        child: Text('Update Profile',style: TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: "Lobster"),),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0,left: 50.0,right: 50.0),
                      child: RaisedButton(
                        color: Colors.black45,
                        onPressed: logoutUser,
                        child: Text('Logout',style: TextStyle(color: Colors.white,fontSize: 16.0,fontFamily: "Lobster"),),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
    );
  }

  logoutUser() async {
    await gSignIn.signOut();
    Navigator.push(context,MaterialPageRoute(builder: (context) => TopLevelPage()));
  }

  Column createProfileNameTextFormField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            'Profile Name', style: TextStyle(color: Colors.black,fontSize: 25,fontFamily: "Lobster"),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.black54),
          controller: profileNameTextEditingController,
          decoration: InputDecoration(
            hintText: 'Write Your Profile Name',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            hintStyle: TextStyle(color: Colors.black),
            errorText: _profileNameValid ? null : 'Profile name is very short',
          ),
        )
      ],
    );
  }

  Column createBioTextFormField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            'Bio', style: TextStyle(color: Colors.black,fontSize: 25,fontFamily: "Lobster"),
          ),
        ),
        TextField(
          style: TextStyle(color: Colors.black),
          controller: bioTextEditingController,
          decoration: InputDecoration(
            hintText: 'Your Bio',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            hintStyle: TextStyle(color: Colors.black54),
            errorText: _bioValid ? null : 'bio is very long',
          ),
        )
      ],
    );
  }

}

