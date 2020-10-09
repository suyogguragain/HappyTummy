import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:happy_tummy/src/pages/TopLevelPage.dart';
import 'package:happy_tummy/src/widgets/HeaderWidget.dart';
import 'package:happy_tummy/src/widgets/ProgressWidget.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;

  CommentsPage({this.postId,this.postOwnerId,this.postImageUrl});

  @override
  CommentsPageState createState() => CommentsPageState(postId: postId, postOwnerId:postOwnerId,postImageUrl: postImageUrl);
}

class CommentsPageState extends State<CommentsPage> {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;
  TextEditingController commenttextEditingController = TextEditingController();


  CommentsPageState({this.postId,this.postOwnerId,this.postImageUrl});

  retrieveComments(){
    return StreamBuilder(
      stream: commentsReferences.document(postId).collection('comments').orderBy("timestamp",descending: false).snapshots(),
      builder: (context,dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(Comment.fromDocument(document));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  saveComment(){
    commentsReferences.document(postId).collection("comments").add({
      'username': currentUser.username,
      'comment': commenttextEditingController.text,
      'timestamp': DateTime.now(),
      'url': currentUser.url,
      'userId': currentUser.id,
      'postId': postId,
    });

    bool isNotPostOwner = postOwnerId !=currentUser.id;
    if(isNotPostOwner){
      activityFeedReferences.document(postOwnerId).collection("feedItems").add({
        'type':'comment',
        'commentData':commenttextEditingController.text,
        'postId':postId,
        'userId':currentUser.id,
        'username':currentUser.username,
        'userProfileImg':currentUser.url,
        'url':postImageUrl,
        'timestamp':timestamp,
      });

    }
    commenttextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context,strTitle: 'Comments'),
      body: Column(
        children: <Widget>[
          Expanded(child: retrieveComments()),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commenttextEditingController,
              decoration: InputDecoration(
                labelText: 'Comment',
                labelStyle: TextStyle(color: Colors.black54,fontFamily: "Lobster",fontSize: 25.0),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            ),
            style: TextStyle(color: Colors.black),
          ),
            trailing: OutlineButton(
                onPressed: saveComment,
                borderSide: BorderSide.none,
              child: Text("Publish",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "EastSeaDokdo",fontSize: 30.0),),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String url;
  final String comment;
  final Timestamp timestamp;
  final String postId;

  Comment({this.username, this.userId, this.url, this.comment, this.timestamp,this.postId});

  factory Comment.fromDocument(DocumentSnapshot documentSnapshot){
    return Comment(
      username: documentSnapshot['username'],
      userId: documentSnapshot['userId'],
      url: documentSnapshot['url'],
      comment: documentSnapshot['comment'],
      timestamp: documentSnapshot['timestamp'],
      postId: documentSnapshot['postId'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0,top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(username + " :  "+ comment, style: TextStyle(fontSize: 18.0,color: Colors.black54,fontFamily: "Lobster"),),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(url),
              ),
              subtitle: Text(tAgo.format(timestamp.toDate()),style: TextStyle(color: Colors.black45),),
            ),
          ],
        ),
      ),
    );
  }
}
