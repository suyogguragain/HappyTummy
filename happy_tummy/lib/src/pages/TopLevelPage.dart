import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/CreateAccountPage.dart';
import 'package:happy_tummy/src/pages/TimelinePage.dart';
import 'package:happy_tummy/src/pages/UploadPage.dart';
import 'package:happy_tummy/src/pages/event_page.dart';
import 'package:happy_tummy/src/pages/home_page.dart';
import 'package:happy_tummy/src/pages/offer_page.dart';
import 'package:happy_tummy/src/pages/post_page.dart';
import 'package:happy_tummy/src/pages/profile_page.dart';
import 'package:happy_tummy/src/pages/signup_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection('users');
final postsReference = Firestore.instance.collection('posts');
final StorageReference storageReference = FirebaseStorage.instance.ref().child('Posts Pictures');
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
  //FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //final _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    // TODO: implement initState
    passwordFocusNode.addListener((){
      if(passwordFocusNode.hasFocus){
        setState(() {
          animationType="test";
        });
      }else{
        setState(() {
          animationType="idle";
        });
      }
    });
    super.initState();

    pageController = PageController();

    gSignIn.onCurrentUserChanged.listen((gSignInAccount){
      controlSignIn(gSignInAccount);
    }, onError: (gError){
      print("Error " + gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount){
      controlSignIn(gSignInAccount);
    }).catchError((gError){
      print("Error " + gError);
    });
  }


  controlSignIn(GoogleSignInAccount signInAccount )async{
    if(signInAccount != null)
    {
      await saveUserInfoToFireStore();
      setState(() {
        isSignedIn = true;
      });

      //configureRealTimePushNotifications();
    }
    else{
      setState(() {
        isSignedIn = false;
      });
    }
  }



//  configureRealTimePushNotifications(){
//    final GoogleSignInAccount gUser = gSignIn.currentUser;
//    if(Platform.isIOS){
//      getIOSPermissions();
//    }
//
//    _firebaseMessaging.getToken().then((token) {
//      usersReference.document(gUser.id).updateData({'androidNotificationToken':token});
//    });
//
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> msg ) async{
//        final String recipientId = msg["data"]["recipient"];
//        final String body = msg["notification"]["body"];
//
//        if(recipientId == gUser.id)
//          {
//            SnackBar snackBar = SnackBar(
//              backgroundColor: Colors.grey,
//              content: Text(body,style: TextStyle(color: Colors.black),overflow: TextOverflow.ellipsis,),
//            );
//            _scaffoldKey.currentState.showSnackBar(snackBar);
//          }
//      },
//    );
//  }
//
//  getIOSPermissions(){
//    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(alert: true,badge: true, sound: true));
//
//    _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
//      print ("Settings Registered : $settings");
//    });
//  }



  saveUserInfoToFireStore() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot = await usersReference.document(gCurrentUser.id).get();

    if (!documentSnapshot.exists){
      final username = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAccountPage()));

      usersReference.document(gCurrentUser.id).setData({
        'id':gCurrentUser.id,
        'profileName':gCurrentUser.displayName,
        'username':username,
        'url':gCurrentUser.photoUrl,
        'email':gCurrentUser.email,
        'bio':'',
        'timestamp':timestamp,
      });
      documentSnapshot = await usersReference.document(gCurrentUser.id).get();
    }

    await followersReferences.document(gCurrentUser.id).collection("userFollowers").document(gCurrentUser.id).setData({ });

    currentUser = User.fromDocument(documentSnapshot);
  }

  void dispose(){
    pageController.dispose();
    super.dispose();
  }


  logInUser() {
    gSignIn.signIn();
  }

  logoutUser() {
    gSignIn.signOut();
  }



  Scaffold buildSignInScreen(){
    return Scaffold(
      //key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //just for vertical spacing
                SizedBox(
                  height: 50,
                  width: 200,
                )    ,
                //space for teddy actor
                Center(
                  child: Container(
                      height: 250,
                      width: 300,
                      child: CircleAvatar(
                        child: ClipOval(
                          child: new FlareActor("assets/teddy_test.flr", alignment: Alignment.center, fit: BoxFit.contain, animation: animationType,),
                        ),
                        backgroundColor: Colors.black45,
                      )
                  ),
                ),
                //just for vertical spacing
                SizedBox(
                  height: 20,
                  width: 10,
                )    ,
                //container for textfields user name and password
                Container(
                  height: 140,
                  width: 350,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.white
                  ),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textAlign: TextAlign.center,
                        onChanged:(value){
                          email = value;
                        },
                        decoration: InputDecoration(border: InputBorder.none, hintText: "Email", contentPadding: EdgeInsets.all(20)),
                      ),
                      Divider(),
                      TextFormField(
                        textAlign: TextAlign.center,
                        onChanged:(value){
                          password = value;
                        },
                        obscureText: true,
                        decoration: InputDecoration(border: InputBorder.none, hintText: "Password", contentPadding: EdgeInsets.all(20)),
//                    controller: passwordController,
                        focusNode: passwordFocusNode,
                      ),
                    ],
                  ),
                ),
                //container for raised button
                Container(
                  width: 350,
                  height: 70,
                  padding: EdgeInsets.only(top: 20),
                  child: RaisedButton(
                    color: Colors.pinkAccent,
                    child: Text("Submit", style: TextStyle(color: Colors.white),),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30),
                    ),
                    onPressed: () async {
                      try{
                        setState(() {
                          showSpinner = true;
                        });
                        final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if (user != null){
                          setState(() {
                            animationType = "success";
                            isSignedIn = true;
                            showSpinner = false;
                          });
                        }else{
                          setState(() {
                            showSpinner = false;
                            isSignedIn = false;
                            animationType = "fail";
                          });
                        }
                      }catch(e){
                        setState(() {
                          isSignedIn = false;
                          showSpinner = false;
                          animationType = "fail";
                        });
                        print(e);
                      }
                    },
                  ),
                ),
                Center(
                  child: Divider(
                    height: 30.0,
                    thickness: 3.0,
                    indent: 80,
                    endIndent:80 ,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Color(0xFFBDC2CB),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    ),
                    SizedBox(width: 5.0),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => SignUpPage()));
                      },
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
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
                    endIndent:120 ,
                  ),
                ),
                Row (
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => logInUser(),
                      child: Container(
                        width: 40.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/google.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Google Login',
                      style: TextStyle(
                        fontSize:12.0,
                        color: Colors.blueGrey,
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
    );
  }

  whenPageChanges (int pageIndex){
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage( int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
  }


  Scaffold buildHomeScreen(){
    return Scaffold(
      body: PageView(
        children: <Widget>[
          TimelinePage(gCurrentUser: currentUser,),
          //RaisedButton.icon(onPressed: logoutUser, icon: Icon(Icons.close), label: Text("Sign out")),
          UploadPage(gCurrentUser: currentUser,),
          EventPage(),
          HomePage(),
          OfferPage(),
          ProfilePage(userProfileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex:  getPageIndex,
        onTap: onTapChangePage,
        backgroundColor: Colors.black,
        activeColor: Colors.pinkAccent,
        inactiveColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.rss_feed,), title: Text("Feed"),),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera,), title: Text("Camera"),),
          BottomNavigationBarItem(icon: Icon(Icons.event,), title: Text("Event"),),
          BottomNavigationBarItem(icon: Icon(Icons.home,), title: Text("Home"),),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer,), title: Text("Offers"),),
          BottomNavigationBarItem(icon: Icon(Icons.person,), title: Text("Profile"),),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (isSignedIn){
      return buildHomeScreen();
    }
    else{
      return buildSignInScreen();
    }
  }
}



