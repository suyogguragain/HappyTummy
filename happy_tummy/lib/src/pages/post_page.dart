
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/profile_page.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> with AutomaticKeepAliveClientMixin<PostPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;

  emptyTextFormField(){
    searchTextEditingController.clear();
  }

  controlSearching(String str){
    Future<QuerySnapshot> allUser = usersReference.where('username',isGreaterThanOrEqualTo:str).getDocuments();
    setState(() {
      futureSearchResults = allUser;
    });
  }

  AppBar searchPageHeader(){
    return AppBar(
      backgroundColor: Colors.black,
       title: TextFormField(
          style: TextStyle(fontSize: 20.0,color: Colors.white,fontFamily:'Roboto',),
          controller: searchTextEditingController,
          decoration: InputDecoration(
              hintText: 'Search Users',
              hintStyle: TextStyle(color: Colors.white),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.lightBlueAccent),
              ),
              filled: true,
              prefixIcon: Icon(Icons.person_pin,color: Colors.white,size:20.0,),
              suffixIcon: IconButton(icon: Icon(Icons.clear_all,color: Colors.white,),
                onPressed:emptyTextFormField,
              )
          ),
          onFieldSubmitted: controlSearching,
        ),
//        Icon(Icons.notifications_none, size: 32.0, color: Colors.pinkAccent,),
//      ],
    );
  }

  Container displayNoSearchResultScreen(){
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Icon(Icons.youtube_searched_for,color: Colors.grey,size: 150.0,),
            Text(
              'Search Users',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500,fontSize: 22.0,fontFamily:'Lobster',),
            ),
          ],
        ),
      ),
    );
  }

  displayUserFoundScreen(){
    return FutureBuilder(
      future: futureSearchResults,
      builder: (context,dataSnapshot){
        if (!dataSnapshot.hasData){
          return circularProgress();
        }

        List <UserResult> searchUsersResult = [];
        dataSnapshot.data.documents.forEach((document){
          User eachUser = User.fromDocument(document);
          UserResult userResult = UserResult(eachUser);
          searchUsersResult.add(userResult);
        });
        return ListView(physics: NeverScrollableScrollPhysics(),
            children: searchUsersResult
        );
      },
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: searchPageHeader(),
      body: futureSearchResults == null ? displayNoSearchResultScreen() : displayUserFoundScreen(),
    );
  }
}


class UserResult extends StatelessWidget {

  final User eachUser;
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap:  () => displayUserProfile(context, userprofileId: eachUser.id),
              child: ListTile(
                contentPadding: EdgeInsets.only(top:4.0,left: 30.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 30.0,
                  backgroundImage: CachedNetworkImageProvider(eachUser.url),
                ),
                title: Text(eachUser.profileName,style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 20.0,
                  fontFamily: 'Lobster',
                ),),
                subtitle: Text(eachUser.username,style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 13.0,
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayUserProfile(BuildContext context, {String userprofileId}){
    Navigator.push( context, MaterialPageRoute(builder: (context) => ProfilePage(userProfileId: userprofileId)));
  }

}
