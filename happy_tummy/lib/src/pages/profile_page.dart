
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/EditProfilePage.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/UploadPage.dart';
import 'package:happy_tummy/src/pages/post_page.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:happy_tummy/src/widgets/PostTileWidget.dart';
import 'package:happy_tummy/src/widgets/PostWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';


User gCurrentUsers;

class ProfilePage extends StatefulWidget {

  final String userProfileId;

  ProfilePage({this.userProfileId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser.id;
  bool loading = false;
  int countPost = 0;
  List <Post> postsList = [];
  String postOrientation ="grid";
  int countTotalFollowers = 0;
  int countTotalFollowings = 0;
  bool following = false;

  void initState(){
    getAllProfilePost();
    getAllFollowers();
    getAllFollowings();
    checkIfAlreadyFollowing();
  }

  getAllFollowers() async{
    QuerySnapshot querySnapshot = await followersReferences.document(widget.userProfileId)
        .collection("userFollowers").getDocuments();

    setState(() {
      countTotalFollowers = querySnapshot.documents.length;
    });
  }


  getAllFollowings() async{
    QuerySnapshot querySnapshot = await followingReferences.document(widget.userProfileId)
        .collection("userFollowing").getDocuments();

    setState(() {
      countTotalFollowings = querySnapshot.documents.length;
    });
  }

  checkIfAlreadyFollowing() async {
    DocumentSnapshot documentSnapshot = await followersReferences.document(widget.userProfileId).collection("userFollowers").document(currentOnlineUserId).get();

    setState(() {
      following = documentSnapshot.exists;
    });
  }

  createProfileTopView(){
    return FutureBuilder(
        future: usersReference.document(widget.userProfileId).get(),
        builder: (context,dataSnapshot){
          if(!dataSnapshot.hasData){
            return circularProgress();
          }
          User user = User.fromDocument(dataSnapshot.data);
          return Padding(
            padding: EdgeInsets.all(17.0),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 45.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(user.url),
                    ),
                    Expanded(
                      flex: 1,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                createColumn('posts',countPost),
                                createColumn('Followers',countTotalFollowers),
                                createColumn('Following',countTotalFollowings),
                              ],
                            ),
                            createButton(),
                          ],
                        ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 13.0),
                  child: Text(
                    user.username,style: TextStyle(fontSize: 24.0,color: Colors.black38,fontFamily: "Lobster"),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5.0,right: 33.0),
                  child: Text(
                    user.profileName,style: TextStyle(fontSize: 16.0,color: Colors.black45),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3.0),
                  child: Text(
                    user.bio,style: TextStyle(fontSize: 14.0,color: Colors.black45),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> PostPage()));
                        },
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        color: Colors.white,
                        elevation: 2.0,
                        textColor: Colors.black,
                        child: Row(
                          children: <Widget>[
                          Text('Search Users  '),
                          Icon(Icons.search)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
    );
  }

  createColumn(String title, int count){
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 20.0, color: Colors.black,fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 16.0, color: Colors.grey,fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  createButton() {
    bool ownProfile = currentOnlineUserId == widget.userProfileId;
    if(ownProfile){
      return createButtonTitleAndFunction(title:'Edit Profile' ,performFunction: editUserProfile,);
    }
    else if(following){
      return createButtonTitleAndFunction(title:'Unfollow' ,performFunction: controlUnfollowUser,);
    }
    else if(!following){
      return createButtonTitleAndFunction(title:'follow' ,performFunction: controlfollowUser,);
    }
  }

  controlUnfollowUser(){
    setState(() {
      following = false;
    });
    followersReferences.document(widget.userProfileId)
        .collection("userFollowers")
        .document(currentOnlineUserId)
        .get()
        .then((document) {
            if(document.exists){
              document.reference.delete();
            }
    });

    followingReferences.document(currentOnlineUserId)
        .collection("userFollowing")
        .document(widget.userProfileId)
        .get()
        .then((document) {
      if(document.exists){
        document.reference.delete();
      }
    });

    activityFeedReferences.document(widget.userProfileId).collection('feedItems')
    .document(currentOnlineUserId).get().then((document) {
      if(document.exists){
        document.reference.delete();
      }
    });

  }

  controlfollowUser(){
    setState(() {
      following = true;
    });

    followersReferences.document(widget.userProfileId).collection("userFollowers")
        .document(currentOnlineUserId)
        .setData({});

    followingReferences.document(currentOnlineUserId).collection("userFollowing")
        .document(widget.userProfileId)
        .setData({});

    activityFeedReferences.document(widget.userProfileId)
        .collection('feedItems').document(currentOnlineUserId)
        .setData({
      "type":"follow",
      "ownerId":widget.userProfileId,
      "username": currentUser.username,
      "timestamp": DateTime.now(),
      "userProfileImg": currentUser.url,
      "userId": currentUser.id,
    });
  }





  Container createButtonTitleAndFunction({String title,Function performFunction}){
    return Container(
      padding: EdgeInsets.only(top: 3.0),
      child: FlatButton(
        onPressed: performFunction,
        child: Container(
          width: 180.0,
          height: 26.0,
          child: Text(
            title,
            style: TextStyle(fontSize: 16.0, color: following ? Colors.grey: Colors.white ,fontWeight: FontWeight.w400),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: following ? Colors.black : Colors.pink,
            border: Border.all(color: following ? Colors.grey : Colors.white70),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }

  editUserProfile(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(currentOnlineUserId: currentOnlineUserId,)));
  }

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
    else if ( postOrientation =='grid'){
      List<GridTile> gridTilesList = [];
      postsList.forEach((eachPost) {
        gridTilesList.add(GridTile(child: PostTile(eachPost)));
      });
      return GridView.count(
        crossAxisCount: 1,
        childAspectRatio: 3.1,
        mainAxisSpacing: 1.5,
        crossAxisSpacing: 1.5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children:  gridTilesList,
      );
    }
//    else if (postOrientation =='list'){
//      return Column(
//        children: postsList,
////        children: <Widget>[
////          Text('Suyog hero'),
////        ],
//      );
//    }
  }


  getAllProfilePost() async {
    setState(() {
      loading = true;
    });

    QuerySnapshot querySnapshot = await postsReference.document(widget.userProfileId).collection("userPosts").orderBy("timestamp",descending: true).getDocuments();

    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postsList = querySnapshot.documents.map((documentSnapshot) => Post.fromDocument(documentSnapshot)).toList();
    });
  }

  createListAndGridPostOrientation(){
    return Padding(
      padding: const EdgeInsets.only(top:8.0,bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Recent Posts",
            style: TextStyle(
            fontSize: 30.0,
            fontFamily: 'Lobster',
            color: Colors.pink,
            wordSpacing: 1.2,
          ),),
//        IconButton(
//            icon: Icon(Icons.grid_on),
//            onPressed: () => setOrientation('grid'),
//            color: postOrientation == 'grid' ? Theme.of(context).primaryColor:Colors.grey,
//        ),
//        IconButton(
//          icon: Icon(Icons.list),
//          onPressed:  () => setOrientation('list'),
//          color: postOrientation == 'list' ? Theme.of(context).primaryColor:Colors.grey,
//        ),
        ],
      ),
    );
  }

  setOrientation(String orientation){
    setState(() {
      this.postOrientation = orientation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,strTitle: "Profile",),
      body: ListView(
        children: <Widget>[
          createProfileTopView(),
          Divider(),
          createListAndGridPostOrientation(),
          displayProfilePost(),
        ],
      ),
    );
  }
}

//FloatingActionButton.extended(
//onPressed: (){
//print("pressed");
//},
//backgroundColor: Colors.white,
//foregroundColor: Colors.black,
//
//icon: Icon(Icons.notifications),
//label: Text('Notifications'),
//),