import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/models/user_model.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:happy_tummy/src/widgets/PostWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context,isAppTitle: true,),
      //body: Column( ),
      body: RefreshIndicator(
          child: createUserTimeLine(),
          onRefresh: () => retrieveTimeline()
      ),
    );
  }
}
