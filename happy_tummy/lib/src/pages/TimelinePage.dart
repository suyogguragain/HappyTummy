import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/NotificationPage.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/pages/post_page.dart';
import 'package:happy_tummy/src/pages/profile_page.dart';
import 'package:happy_tummy/src/widgets/PostWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:swipedetector/swipedetector.dart';


class TimelinePage extends StatefulWidget {
  final User gCurrentUser;
  TimelinePage({this.gCurrentUser});

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {

  List<Post> posts;
  List<String> followingsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  retrieveTimeline() async{
    QuerySnapshot querySnapshot = await timelineReferences.document(widget.gCurrentUser.id).collection("timelinePosts").orderBy("timestamp",descending: true).getDocuments();

    List<Post> allPosts = querySnapshot.documents.map((document) => Post.fromDocument(document)).toList();

    setState(() {
      this.posts = allPosts;
    });
  }


  retrieveFollowings() async{
    QuerySnapshot querySnapshot = await followingReferences.document(widget.gCurrentUser.id).collection("userFollowing").getDocuments();

    setState(() {
      followingsList = querySnapshot.documents.map((document) => document.documentID).toList();
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveTimeline();
    retrieveFollowings();
  }

  createUserTimeLine(){
    if(posts == null){
      return circularProgress();
    }else{
      return ListView(
        children: posts,
      );
    }
  }


  //Sidenavbar

  FSBStatus status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text( "HappyTummy",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "PermanentMarker",
            fontSize: 32.0,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      //body: Column( ),
//      body: RefreshIndicator(
//          child: createUserTimeLine(),
//          onRefresh: () => retrieveTimeline()
//      ),
      body: SwipeDetector(
        onSwipeLeft: (){
          status = FSBStatus.FSB_CLOSE;
        },
        onSwipeRight: (){
          status = FSBStatus.FSB_OPEN;
        },

        child: FoldableSidebarBuilder(
            status: status,
            drawer: CustomDrawer(
              closeDrawer: () {
                setState(() {
                  status = FSBStatus.FSB_CLOSE;
                });
              },
            ),
            screenContents: RefreshIndicator(
              child: createUserTimeLine(),
              onRefresh: () => retrieveTimeline()
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: ( ) {
          setState(() {
            status = status == FSBStatus.FSB_OPEN ? FSBStatus.FSB_CLOSE  : FSBStatus.FSB_OPEN;
          });
        },
        child: Icon(Icons.menu,color: Colors.black,),
      ),
    );
  }
}


class CustomDrawer extends StatelessWidget {

  final Function closeDrawer;

  const CustomDrawer({Key key, this.closeDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Container(
      color: Colors.white,
      width: mediaQuery.size.width * 0.60,
      height: mediaQuery.size.height,
      child: Column(
        children: <Widget>[
          Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey.withAlpha(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80),
                      image: DecorationImage(
                        image: AssetImage('assets/images/ht.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              )),
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage(userProfileId: currentUser.id,)));
              closeDrawer;
            },
            leading: Icon(Icons.person),
            title: Text(
              "Your Profile",
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              debugPrint("Tapped settings");
            },
            leading: Icon(Icons.settings),
            title: Text("Settings"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPage()));
              closeDrawer;
            },
            leading: Icon(Icons.notifications),
            title: Text("Notifications"),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => PostPage()));
              closeDrawer;
            },
            leading: Icon(Icons.person),
            title: Text(
              "Search Users",
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey,
          ),
          ListTile(
            onTap: () async {
              await gSignIn.signOut();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => TopLevelPage()));
              closeDrawer;
            },
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out"),
          ),
        ],
      ),
    );
  }
}
