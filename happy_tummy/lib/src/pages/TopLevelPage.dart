import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:happy_tummy/restaurant/restaur.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/TimelinePage.dart';
import 'package:happy_tummy/src/pages/UploadPage.dart';
import 'package:happy_tummy/src/pages/event_page.dart';
import 'package:happy_tummy/src/pages/home_page.dart';
import 'package:happy_tummy/src/pages/offer_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:swipedetector/swipedetector.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection('users');
final postsReference = Firestore.instance.collection('posts');
final StorageReference storageReference =
    FirebaseStorage.instance.ref().child('Posts Pictures');
final activityFeedReferences = Firestore.instance.collection('feed');
final commentsReferences = Firestore.instance.collection('comments');
final followersReferences = Firestore.instance.collection('followers');
final followingReferences = Firestore.instance.collection('following');
final timelineReferences = Firestore.instance.collection('timeline');

final DateTime timestamp = DateTime.now();
User currentUser;

class TopLevelPage extends StatefulWidget {
  @override
  _TopLevelPageState createState() => _TopLevelPageState();
}

class _TopLevelPageState extends State<TopLevelPage> {
  bool isSignedIn = false;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String password;
  String animationType = "idle";
  final passwordFocusNode = FocusNode();
  PageController pageController;
  int getPageIndex = 0;
  FSBStatus status;
  //final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        setState(() {
          animationType = "test";
        });
      } else {
        setState(() {
          animationType = "idle";
        });
      }
    });
    super.initState();

    pageController = PageController();

    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }, onError: (gError) {
      print("Error " + gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError) {
      print("Error " + gError);
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveUserInfoToFireStore();

      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  saveUserInfoToFireStore() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersReference.document(gCurrentUser.id).get();

    if (!documentSnapshot.exists) {
      usersReference.document(gCurrentUser.id).setData({
        'id': gCurrentUser.id,
        'profileName': gCurrentUser.displayName,
        'username': gCurrentUser.displayName,
        'url': gCurrentUser.photoUrl,
        'email': gCurrentUser.email,
        'bio': '',
        'timestamp': timestamp,
      });
      documentSnapshot = await usersReference.document(gCurrentUser.id).get();
    }

    await followersReferences
        .document(gCurrentUser.id)
        .collection("userFollowers")
        .document(gCurrentUser.id)
        .setData({});

    currentUser = User.fromDocument(documentSnapshot);
  }

  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  logInUser() {
    gSignIn.signIn();
  }

  logoutUser() {
    gSignIn.signOut();
  }

  Scaffold buildSignInScreen() {
    return Scaffold(
      backgroundColor: Colors.black54,
      //key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black54, Colors.black]),
        ),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //just for vertical spacing
                  SizedBox(
                    height: 100,
                    width: 200,
                  ),
                  //space for teddy actor
                  Center(
                    child: Container(
                        height: 250,
                        width: 300,
                        child: CircleAvatar(
                          child: ClipOval(
                            child: new FlareActor(
                              "assets/teddy_test.flr",
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              animation: animationType,
                            ),
                          ),
                          backgroundColor: Colors.grey.shade400,
                        )),
                  ),
                  //just for vertical spacing
                  SizedBox(
                    height: 20,
                    width: 10,
                  ),
                  Container(
                    width: 280,
                    height: 70,
                    padding: EdgeInsets.only(top: 20),
                    child: RaisedButton(
                        color: Colors.grey.shade200,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 60.0,
                              height: 35.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/google.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Text(
                              "Google Sign In",
                              style: TextStyle(
                                  color: Colors.grey.shade700, fontSize: 22),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30),
                        ),
                        onPressed: () async {
                          setState(() {
                            animationType = "success";
                            //isSignedIn = true;
                            showSpinner = false;
                          });
                          logInUser();
                        }),
                  ),
                  Center(
                    child: Divider(
                      height: 30.0,
                      thickness: 3.0,
                      indent: 80,
                      endIndent: 80,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "I'm a restaurant?",
                        style: TextStyle(
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                      SizedBox(width: 5.0),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (BuildContext context) => res()));
                        },
                        child: Text(
                          "Sign In Here",
                          style: TextStyle(
                              color: Colors.pink,
                              fontWeight: FontWeight.normal,
                              fontSize: 18.0),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: Divider(
                      height: 30.0,
                      thickness: 2.0,
                      indent: 120,
                      endIndent: 120,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          image: DecorationImage(
                            image: AssetImage('assets/images/ht.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Happy Tummy',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
      body: SwipeDetector(
        onSwipeLeft: () {
          status = FSBStatus.FSB_CLOSE;
        },
        onSwipeRight: () {
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
          screenContents: PageView(
            // child: PageView(
            children: <Widget>[
              TimelinePage(
                gCurrentUser: currentUser,
              ),
              UploadPage(
                gCurrentUser: currentUser,
              ),
              HomePage(),
              EventPage(
                gCurrentUser: currentUser,
              ),
              OfferPage(),
              //ProfilePage(userProfileId: currentUser?.id),
            ],
            controller: pageController,
            onPageChanged: whenPageChanges,
            physics: NeverScrollableScrollPhysics(),
          ),
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChangePage,
        backgroundColor: Colors.black,
        activeColor: Colors.blueGrey,
        inactiveColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.rss_feed,
            ),
            title: Text("Feed"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
            ),
            title: Text("Camera"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event,
            ),
            title: Text("Event"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_offer,
            ),
            title: Text("Offers"),
          ),
          //BottomNavigationBarItem(icon: Icon(Icons.person,), title: Text("Profile"),),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            status = status == FSBStatus.FSB_OPEN
                ? FSBStatus.FSB_CLOSE
                : FSBStatus.FSB_OPEN;
          });
        },
        child: Icon(
          Icons.menu,
          color: Colors.blueGrey,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }
}
